     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Cmplnce Wtch Lst Msg Status Engine Feeder')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDRWSENG - Midas Compliance Watch List Message Status        *
      *             Engine Feeder                                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 221249             Date 10Sep03               *
      *                 CSD015  *CREATE    Date 03Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  221249 - Comp Watch jobs not ending                          *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FMGOREFL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas Message Reference by TRNO
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Rundate dataarea layout file
 
     D SDWLMSDS      E DS                  EXTNAME(SDWLMSPD)
      ** Midas Watch List Message Status Queue
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PDtqNam         S             10A
     D PDtqLib         S             10A
     D PDtqLen         S              5  0
     D PDtqWait        S              5  0
     D PDtqDta         S            100A
     D PObject         S             10A
     D PLib            S             10A
     D PObjType        S              7A
     D PLockState      S              7A
     D PMember         S             10A
     D PWaitTime       S              6A
     D PDlcobj         S              1A
     D PReturn         S              7A
 
     D WRun            S              1A
     D WrFUNT          S              8A
     D WrIDEN          S             40A
     D WrBRCH          S              3A
     D WIden16         S             16A
     D @END            S              3A                                        221249
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** While Dataqueue data is not 'END'
 
     C*******************DOW       W8RTCD  <> 'END'                             221249
     C                   DOW       @END    <> 'END'                             221249
 
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    PDtqNam
     C                   PARM                    PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PDtqDta
     C                   PARM                    PDtqWait
     C                   MOVEL     PDtqDta       SDWLMSDS
     C                   MOVEL     W8RTCD        @END                           221249
 
     C*******************IF        W8RTCD  <> 'END'                             221249
     C                   IF        @END    <> 'END'                             221249
 
     C                   EXSR      SRMessage
 
     C                   EXSR      SRChkRtcd
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** End of Program
 
     C                   EXSR      SREnd
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMessage - Update Message Reference File                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRMessage     BEGSR
 
     C                   IF        (W8RTCD = '*NOHIT' OR
     C                             W8RTCD = '*NOCHK') AND
     C                             W8ARLS = 'Y'
 
     C                   EVAL      WIden16 = W8IDEN
     C     WIden16       CHAIN     MGOREFL0                           01
 
     C                   IF        *IN01 = *OFF AND
     C                             MGST = 'CRTD'
 
     C                   EVAL      MGST = 'RSND'
     C                   EVAL      MGSG = '2'
     C                   EVAL      RELD = AGMRDT
     C                   TIME                    RELT
     C                   UPDATE    MGOREFD0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkRtcd - Check Return Code                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRChkRtcd     BEGSR
 
     C                   IF        W8RTCD = '*INIT'   OR
     C                             W8RTCD = '*OPEN'   OR
     C                             W8RTCD = '*NREADY' OR
     C                             W8RTCD = '*FOFEXE' OR
     C                             W8RTCD = '*SRVNAM' OR
     C                             W8RTCD = '*DBNAME' OR
     C                             W8RTCD = '*USRNAM' OR
     C                             W8RTCD = '*PASSWD'
     C                   MOVEL     'END'         W8RTCD
     C                   MOVEL     'END'         @END                           221249
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End of Program                                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
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
 
      ** Retrive rundate details
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Initialise Data queue parameters
 
     C                   EVAL      PDtqNam = 'SDCWSDTQ'
     C                   EVAL      PDtqLib = '*LIBL'
     C                   EVAL      PDtqLen = 100
     C                   EVAL      PDtqWait = -1
 
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
