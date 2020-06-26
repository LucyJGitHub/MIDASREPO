     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Create FTP Commands for PEA')                 *
/*XBI1*  CRTSRCPF FILE(QTEMP/FTPCOMMAND) RCDLEN(212) MBR(INPUT)       *
/*XBI2*  OVRDBF INPUT FTPCOMMAND INPUT                                *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000111 - Create FTP Commands for PEA                       *
      *                                                               *
      *  Function:  This module creates the FTP commands to send      *
      *             and save objects to PEA system.                   *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. AR1042300          Date 14Oct12               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1042300 - PEA Restore of files in global layer required    *
      *              (Child:AR1042301)                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Output file for FTP commands
     FINPUT     O    E             DISK
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @RUN            S              1A
 
      ** Parameters
     D RemoteUser      S             10A
     D Password        S             10A
     D Object          S             10A
     D FromLib         S             10A
     D ToLib           S             10A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** First set up the user and password
 
     C                   EVAL      SRCDTA = RemoteUser + ' ' +
     C                             Password
     C                   WRITE     FTPCommand
 
      ** Set binary representation
 
     C                   EVAL      SRCDTA = 'BIN'
     C                   WRITE     FTPCommand
 
     C                   EVAL      SRCDTA = 'PUT ' + %Trim(FromLib) +
     C                             '/' + %Trim(Object) + '.savf ' +
     C                             %Trim(ToLib) + '/' + %Trim(Object) +
     C                             '.savf'
     C                   WRITE     FTPCommand
                                                                                          AR1042300
      ** Send Global DBIC                                                                 AR1042300
                                                                                          AR1042300
     C                   EVAL      Object = 'DBICGM'                                      AR1042300
     C                   EVAL      SRCDTA = 'PUT ' + %Trim(FromLib) +                     AR1042300
     C                             '/' + %Trim(Object) + '.savf ' +                       AR1042300
     C                             %Trim(ToLib) + '/' + %Trim(Object) +                   AR1042300
     C                             '.savf'                                                AR1042300
     C                   WRITE     FTPCommand                                             AR1042300
 
      ** Set Quit message
 
     C                   EVAL      SRCDTA = 'QUIT'
     C                   WRITE     FTPCommand
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RemoteUser
     C                   PARM                    Password
     C                   PARM                    Object
     C                   PARM                    FromLib
     C                   PARM                    ToLib
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
