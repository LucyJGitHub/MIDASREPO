     H***DEBUG*ALWNULL(*INPUTONLY)                                                          MD026161
     H DEBUG ALWNULL(*USRCTL)                                                               MD026161
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Global update T_GZAMADEX')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  GPT_AMADEX- Midas GO Global update T_GZAMADEX                *
      *              database update                                  *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD026161           Date 04Apr14               *
      *                 AR658311           Date 15Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25565A *CREATE  Date 25Aug09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026161 - ALWNULL(*INPUTONLY) only allows read of null      *
      *             values. Use ALWNULL(*USRCTL) instead since this   *
      *             prgram updates T_GZAMADEX.                        *
      *  AR658311 - Failed to compile GPT_AMADEX using Bridge for     *
      *             global program                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25565A - Can't authorise a re-used Retail Account No      *
      *              Midas GO Global update T_GZAMADEX                *
      *              sync T_GZAMADEX with ACCNTAB                     *
      *                                                               *
      *****************************************************************
 
     FT_GZAMADEXUF   E             DISK    RENAME(T_GZAMADEX: GZAMADEX)
     F                                     COMMIT(P#COM) USROPN
     F                                     INFSR(*PSSR)
      ** Midas GZ AMAD extension table
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
     D***/COPY*ZACPYSRC,STD_D_SPEC                                                          AR658311
     D/COPY GPCPYSRCG,STD_D_SPEC                                                            AR658311
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)                          AR658311
      * Array containing Copyright statement                                                AR658311
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
 
     D DSCUSN          DS
     D    WCUSF                      10A
     D    WBRCH                1      3A
     D    WFILL                4      4A
     D    WCUSN                5     10A
 
     D DSPARM          DS
     D    WCCY                        3A
     D    WACOD                      10A
     D    WACSQ                       2A
     D    WBRCA                       3A
 
     D WValBrch        S              1A
     D WRun            S              1A
 
     D P#RTCD          S              7A
     D P#OPTN          S              7A
     D P#RETL          S             10A
     D P#CNUM          S              6A
     D P#CCY           S              3A
     D P#ACCD          S             10A
     D P#ACSQ          S              2A
     D P#BRCH          S              3A
     D P#COM           S              1A
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
     C     1             SetLL     T_GZAMADEX
     C                   Read      T_GZAMADEX
 
     C                   DoW       NOT %EOF
     C                   Eval      WCUSF = DDCUSN
     C                   Eval      WCCY  = %trim(DDCCY)
     C                   Eval      WACOD = DDACOD
     C                   Eval      WACSQ = DDACSQ
     C                   Eval      WBRCA = %trim(DDBRCA)
 
     C                   ExSr      SRBRCH
 
     C                   If        WValBrch = 'Y'
     C                   ExSr      SRACCTR
     C                   EndIf
     C                   Clear                   DSPARM
     C                   Clear                   DSCUSN
 
     C                   Read      T_GZAMADEX
     C                   EndDo
 
     C                   Eval      *INLR = *on
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   Call      'GPCOPN4COM'
     C                   Parm                    P#COM
     C                   Open      T_GZAMADEX
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBRCH - Check if branch used for costumer exists             *
      *                                                               *
      *****************************************************************
     C     SRBRCH        BegSr
 
     C                   If        WBRCA <> P#BRCH
     C                   Clear                   DSSDY
     C                   Eval      WValBrch = 'Y'
     C                   Eval      P#BRCH = WBRCA
 
     C                   Call      'AOBRCHR1'
     C                   Parm      *Blanks       P#RTCD
     C                   Parm      '*KEY'        P#OPTN
     C                   Parm                    P#BRCH
     C                   Parm                    DSSDY
 
     C                   If        P#RTCD <> *BLANKS
     C                   Eval      WValBrch = 'N'
     C                   EndIf
 
     C                   EndIf
 
     C                   EndSr
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACCTR -  Check if current record exist in ACCNTAB file      *
      *                                                               *
      *****************************************************************
     C     SRACCTR       BegSr
 
     C                   Clear                   DSSDY
 
     C                   Call      'AOACCTR0'
     C                   Parm      *BLANKS       P#RTCD
     C                   Parm      '*KEY     '   P#OPTN
     C                   Parm      *BLANKS       P#RETL
     C                   Parm      WCUSN         P#CNUM
     C                   Parm      WCCY          P#CCY
     C                   Parm      WACOD         P#ACCD
     C                   Parm      WACSQ         P#ACSQ
     C                   Parm                    P#BRCH
     C                   Parm                    DSSDY
 
     C                   If        P#RTCD = '*NRF   '
     C                   Delete    T_GZAMADEX
     C                   ElseIf    P#RTCD <> *BLANKS
     C     *LOCK         In        LDA
     C                   Eval      DBPGM  = 'GPT_AMADEX'
     C                   Eval      DBFILE = 'ACCNTAB'
     C                   Eval      DBKEY  = P#CNUM + P#CCY + P#ACCD +
     C                                      P#ACSQ+ P#BRCH
     C                   Eval      DBASE  = 1
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   EndSr
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
 
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2009
