     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
     H THREAD(*SERIALIZE)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Open Client Connection to OFAC-Agent Srvr')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SDOFACOP - Open Client Connection to OFAC-Server             *
      *                                                               *
      *  Function:  This program initialise the OFAC-AGENT server,    *
      *             open it and check if server is ready to process   *
      *             request.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD015  *CREATE    Date 03Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
 
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D P_Retcd         S              7
     D P_Optn          S              7
      ** Parameter for calling AOCWCDR0
 
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
      ** Short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D OFACString      S          30000
      ** Field content separated by 1 space
 
     D PRetCode        S              7A
     D PServ           S               *
      ** Entry Parameters
 
     D Result          S              3
     D Action          S              2
     D res             S             10I 0
     D LoopCnt         S              1  0
 
      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+
 
      * Source Included from FOFAPI
 
     DFofInit          PR            10I 0 EXTPROC('FofInit')
     D host                            *   VALUE OPTIONS(*STRING)
     D service                         *   VALUE OPTIONS(*STRING)
     D openNow                       10I 0 VALUE
     D Pserver                         *
 
     DFofOpen          PR            10I 0 EXTPROC('FofOpen')
     D Pserver                         *   VALUE
 
      * End of Source copy from FOFAPI
 
      * object used to store object returned by the case constructor
     D caseobject      S               O   CLASS(*JAVA:
     D                                     'com.misys.midas.casemgt.Case')
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialise OFAC-Agent Server
 
     C                   MOVEL     'I '          Action
     C                   EVAL      res=FofInit(W1MDSR:W1OFSR:
     C                                            0:PServ)
 
     C                   EVAL      LoopCnt = 0
     C                   DOW       res <> *ZERO AND LoopCnt <> 5
     C                   CALLB     'ZACDELAY'
     C                   MOVEL     'I '          Action
     C                   EVAL      res=FofInit(W1MDSR:W1OFSR:
     C                                            0:PServ)
     C                   EVAL      LoopCnt = LoopCnt + 1
     C                   ENDDO
 
     C                   IF        res <> *ZERO
     C                   GOTO      ENDMAIN
     C                   ENDIF
 
      ** Open Client Connection to OFAC-AGENT Server
 
     C     res           IFEQ      *zero
     C                   MOVEL     'O '          Action
     C                   EVAL      res=FofOpen(PServ)
     C                   EVAL      LoopCnt = 0
     C                   DOW       res <> *ZERO AND LoopCnt <> 5
     C                   CALLB     'ZACDELAY'
     C                   MOVEL     'O '          Action
     C                   EVAL      res=FofOpen(PServ)
     C                   EVAL      LoopCnt = LoopCnt + 1
     C                   ENDDO
     C                   IF        res <> *ZERO
     C                   GOTO      ENDMAIN
     C                   ENDIF
     C                   ELSE
     C                   EVAL      PRetCode = '*INIT'
     C                   GOTO      EndMain
     C                   ENDIF
 
      ** Check for Initialisation Errors and return if error condition
 
     C     res           IFNE      *zero
     C                   EVAL      PRetCode = '*OPEN'
     C                   MOVE      res           result
     C                   ENDIF
 
     C     EndMain       TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C
     C
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
 
     C     *entry        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    PServ
 
      ** Retrieve configuration data for linking both the OFAC-Agent and
      ** the Compliance Alert Software
 
     C                   CALLB     'AOCWCDR0'
     C                   PARM      *BLANKS       P_Retcd
     C                   PARM      '*FIRST '     P_Optn
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
     C                   IF        P_Retcd <> *Blanks
     C                   EVAL      DBFILE = 'SDCWCDPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = P_Optn
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *
      * Uncomment line below to turn on the FircoSoft trace.
      * Replace 'LIB' with existing library name, i.e. 'NMXLIB'.
      * Replace 'FILE' with output trace file name. This does not
      * need to exist. The name must be 7 characters or less in length.
      * Note that the file created has 'LOG' appended to the name.
      * I.e. 'FILE' becomes 'FILELOG' in library 'LIB'.
      *
     C*                  EVAL      res=FkCommTraceOn('LIB':'FILE')
      *
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
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
