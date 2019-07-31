     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
     H THREAD(*SERIALIZE)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Shutdown compliance watch OFAC-Agent srvr')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SDCWSHDN - Shutdown Compliance Watch OFAC-AGENT Server       *
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
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S              7A
     D PServ           S               *
 
     D PMDSR           S             50A
     D POFSR           S             32A
     D Action          S              2A
     D res             S             10I 0
 
      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+
 
     DFofInit          PR            10I 0 EXTPROC('FofInit')
     D host                            *   VALUE OPTIONS(*STRING)
     D service                         *   VALUE OPTIONS(*STRING)
     D openNow                       10I 0 VALUE
     D Pserver                         *
 
     DFofOpen          PR            10I 0 EXTPROC('FofOpen')
     D Pserver                         *   VALUE
 
     DFofShutdown      PR            10I 0 EXTPROC('FofShutdown')
     D Pserver                         *   VALUE
 
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
 
      ** Initialise OFAC-Agent Server
 
     C                   MOVEL     'I '          Action
     C                   EVAL      res=FofInit(PMDSR:POFSR:
     C                                            0:PServ)
 
      ** Open Client Connection to OFAC-AGENT Server
 
     C                   IF        res = *zero
     C                   MOVEL     'O '          Action
     C                   EVAL      res=FofOpen(PServ)
     C                   ENDIF
 
      ** Shutdown OFAC-AGENT server
 
     C                   IF        res = *zero
     C                   EVAL      res=FofShutdown(PServ)
     C                   ENDIF
 
     C                   MOVEL     *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMDSR
     C                   PARM                    POFSR
 
     C                   ENDSR
 
