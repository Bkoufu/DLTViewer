#
CXXFLAGS +=-Wunused

TEMPLATE = subdirs
CONFIG   += ordered
SUBDIRS  += parser
CONFIG += c++11
CONFIG -= entrypoint
pro: QT += serialport
