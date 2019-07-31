     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000142 - Global Processing data download, MM deals         *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD037829 *CREATE   Date 23May16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037829 - Unauthorised PT are not shown on Dashboard        *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     FMMPTRMPD  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
 
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D                 DS
     D  CountN                 1      5  0
     D  CountA                 1      5
      *
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      * Midas Local Data Area for database error reporting
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      * The following fields are defined in the external file:
      *                                     134 141 DBFile
      *                                     142 170 DBKey
      *                                     171 180 DBPgm
      *                                     181 1830DBase
      *                                     184 193 DBMod
      *                                     194 203 DBProc
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
     D Value           S             50
     D APIType         S              4
      *
      ** Variables for AOBANKR0
      *
     D @RTCD           S              7
     D @OPTN           S             50
      *
      ** Variables for GOGETZONE
      *
     D PZRTCD          S              7
     D PZERMS          S             50
     D PZFCHK          S              1
     D PZZONE          S             10
     D PZSHTC          S              4
     D PZRDNB          S              5  0
     D PZDNWD          S              5  0
     D PZBCCY          S              3
     D PZNJOB          S              1  0
     D WZONE           S             10
      *
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C/COPY GOCPYSRC,GOUPD_PARM
      *
      ** Get Zone
      *
     C                   EXSR      SRINIT
     C                   EXSR      SRGPGZ
      *
      ** Unauthorised Penalty Termination
      *
     C                   IF        Key_Desc = 'UnauthMMPenaltyTime'
     C                   EVAL      APIType = 'PTRM'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C                   IF        MidasPhase <> 'A' AND
     C                             MidasPhase <> 'G'
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
      ** Check MM NAS bought deals file
      *
     C                   OPEN      MMPTRMPD
     C     1             SETLL     MMPTRMPD
     C                   READ      MMPTRMPD                               80
     C                   DOW       *IN80 = *OFF
      *
     C                   IF        PTRECI = 'D' AND
     C                             PTUSRX = *BLANKS AND
     C                             PTMDAT >= BJRDNB
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
      *
     C                   READ      MMPTRMPD                               80
     C                   ENDDO
      *
     C                   CLOSE     MMPTRMPD
      *
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C/COPY GOCPYSRC,GOUPD_DWNL
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Gets Bank Details                                    *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGPGZ - Gets the Zone.                                       *
      *                                                               *
      * Calls: GOGETZONE                                              *
      *                                                               *
      *****************************************************************
     C     SRGPGZ        BEGSR
      *
     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       PZRTCD
     C                   PARM      *BLANKS       PZERMS
     C                   PARM      'N'           PZFCHK
     C                   PARM      *BLANKS       PZZONE
     C                   PARM      *BLANKS       PZSHTC
     C                   PARM      *ZERO         PZRDNB
     C                   PARM      *ZERO         PZDNWD
     C                   PARM      *BLANKS       PZBCCY
     C                   PARM      *ZERO         PZNJOB
      *
     C     PZRTCD        IFEQ      *BLANKS
     C                   MOVE      PZZONE        WZONE
     C                   ELSE
      *
     C     PZRTCD        IFEQ      '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   SetOn                                        U7U8
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
