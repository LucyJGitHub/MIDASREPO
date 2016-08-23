     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Download data control - SDBANKPD')            *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000100 - Global Processing data dowload, SDBANKPD          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD020167           Date 23Apr13               *
      *  Prev Amend No. CCB023             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9512            Date 05Dec05               *
      *                 CUP096             Date 15Mar05               *
      *                 CGP002  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring (Recompile)                           *
      *  BUG9512 - Signal errors to calling program in U7U8.          *
      *  CUP096 - Retrieve run day number rather than date.           *
      *  CGP002 - Global Processing data download                     *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN                                            BUG9512
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * External data structure for bank details
     DSDBANK         E DS                  EXTNAME(SDBANKPD)
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
     D                 DS                                                                     CUP096
     D  RunDayNumberN          1      5  0                                                    CUP096
     D  RunDayNumberA          1      5                                                       CUP096
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
     D Value           S             50
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
      * Retrieve data.
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Run Date
     C                   IF        Key_Desc = 'RunDate'
     C*****              EVAL      Value = BJMRDT                                             CUP096
     C                   EVAL      RunDayNumberN = BJRDNB                                     CUP096
     C                   EVAL      Value = RunDayNumberA                                      CUP096
     C                   ENDIF
      * Next working day
     C                   IF        Key_Desc = 'NextWorkingDay'
     C*****              CALL      'ZDATE2'                                                   CUP096
     C*****              PARM                    BJDNWD                                       CUP096
     C*****              PARM                    BJDFIN                                       CUP096
     C*****              PARM      0             ZDATE             6 0                        CUP096
     C*****              PARM                    NextWorkingDay    7                          CUP096
     C*****              EVAL      Value = NextWorkingDay                                     CUP096
     C                   EVAL      RunDayNumberN = BJDNWD                                     CUP096
     C                   EVAL      Value = RunDayNumberA                                      CUP096
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
     C                   SetOn                                        U7U8                   BUG9512
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
