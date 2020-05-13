     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas XX Calculate FCM101 Final Spread Rate')          *
      *****************************************************************
      *                                                               *
      *  Midas - Common Processing                                    *
      *                                                               *
      *  XXCALCSPRT - Midas XX Calculate Final Spread Rate            *
      *                                                               *
      *  Function:  This program will accept Lending Floor Rates      *
      *             parameters and return the new spread rate based   *
      *             on the FCM101 Floor Rates requirement.            *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. FCM101 *CREATE     Date 22Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FCM101 - Floor Rates in LE Module                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+


      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

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

      ** Entry parameters
     D PRetCode        S              7
     D PBaserate       S             11  7
     D PBaseFloor      S             11  7
     D PBseFlrSig      S              1
     D PAllInFlor      S             11  7
     D PAllInSign      S              1
     D PConSpread      S             11  7
     D PCNSPsign       S              1
     D PNewSpread      S             11  7
     D PFinalRate      S             11  7
     D PNewSpreadSign  S              1

      ** Work variables
     D WFinRate        S             11  7
     D Wrk_BRTE_CNSP   S             11  7
     D Wrk_BRTF_CNSP   S             11  7
     D WBseRteCNSP     S             11  7
     D WBseFLRCNSP     S             11  7
     D WRun            S              1

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Main processing to compute rate and spread
      *
     C                   EXSR      SRInit
     C                   EXSR      SRMain
      *
      ** Return to the calling program
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Main Processing                                     *
      *                                                               *
      *****************************************************************

     C     SRMain        BEGSR

     ** Add Contractual Spread
     C                   IF        PCNSPSign = 'A'

      ** Calculate higher of Base Rate +/-/P of Contractual Spread Rate
      ** OR All-in Interest Rate
      *
     C                   EVAL      WBseRteCNSP = PBaserate  + PConSpread

     C                   If        PBseFLRSig <> ' '
     C                   EVAL      WBseFLRCNSP = PBaseFloor + PConSpread
     C                   Endif
      *

     C                   ELSEIF    PCNSPSign = 'S'

     ** Subtract Contractual Spread
     C                   EVAL      WBseRteCNSP = PBaserate  - PConSpread

     C                   If        PBseFlrSig <> ' '
     C                   EVAL      WBseFLRCNSP  = PBaseFloor - PConSpread
     C                   Endif
      *
     C                   ELSEIF    PCNSPSign = 'P'

     ** Percentage of Contractual Spread

     C                   EVAL(H)   Wrk_BRTE_CNSP = (PBaserate * PConSpread)/ 100
     C                   EVAL      WBseRteCNSP = Wrk_BRTE_CNSP

     C                   If        PBseFlrSig <> ' '
     C                   EVAL(H)   Wrk_BRTF_CNSP = (PBaseFloor * PConSpread)/100
     C                   EVAL      WBseFLRCNSP = Wrk_BRTF_CNSP
     C                   ENDIF

     C                   ELSEIF    PCNSPSign = ' '

     C                   EVAL      WBseRteCNSP = PBaserate

     C                   If        PBseFLRSig <> ' '
     C                   EVAL      WBseFLRCNSP = PBaseFloor
     C                   Endif
     C
     C                   ENDIF
      *
      ** Use greater value All-in Interest Rate Floor
      ** vs  Base Rate +/-/P Contractual Spread
      *
     C                   SELECT

     C                   WHEN      PAllInSign <> ' '
      *
     C                   If        PAllInFlor >= WBseRteCNSP
     C                   Eval      WFinRate   = PAllInFlor
      *
      ** Default new Spread Rate Sign
      *
     C                   If        PCNSPSign <> 'P'
     C                   Eval      PNewSpreadSign = 'A'
     C                   Endif

     C                   Else
     C                   Eval      WFinRate   = WBseRteCNSP
     C                   Endif

     C                   WHEN      PBseFlrSig <> ' '

     C                   If        WBseFlrCNSP >= WBseRteCNSP
     C                   Eval      WFinRate   = WBseFlrCNSP
      *
     C                   If        PCNSPSign <> 'P'
     C                   Eval      PNewSpreadSign = 'A'
     C                   Endif

     C                   Else
     C                   Eval      WFinRate   = WBseRteCNSP
     C                   Endif

     C                   OTHER
     C                   Eval      WFinRate   = WBseRteCNSP

     C                   EndSL
      *
      ** Save Final Rate
     C                   Eval      PFinalRate = WFinRate
      *
      ** Calculate Final Spread
      *
     C                   IF        PCNSPSign = 'P'
     C                   EVAL(H)   PNewSpread = (WFinRate/PBaserate) * 100
     C                   ELSEIF    PCNSPSign = 'A'
     C                   EVAL      PNewSpread = WFinRate - PBaserate
     C                   ELSEIF    PCNSPSign = 'S' or PNewSpreadSign = 'A'
     C                   EVAL      PNewSpread = WFinRate - PBaserate
      *
     C                   If        PNewSpread < 0 and PCNSPSign = 'S'
     C                   Eval      PNewSpread = PNewSpread * -1
     C                   Eval      PNewSpreadSign  = 'S'
     C                   Endif
      *
     C                   ELSEIF    PCNSPSign = ' '
     C                   EVAL      PNewSpread = PConSpread
     C
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - SR. for initialisation after program initial call    *
      *                                                               *
      *****************************************************************

     C     SRInit        BEGSR
      *
     C                   Eval       PRetCode   = *Blanks
     C                   Eval       PNewSpread = *ZERO
     C                   Eval       PFinalRate = *ZERO
     C                   Eval       WFinRate   = *Zero
     C                   Eval       Wrk_BRTE_CNSP = *Zero
     C                   Eval       Wrk_BRTF_CNSP = *Zero
     C                   Eval       WBseRteCNSP = *Zero
     C                   Eval       WBseFLRCNSP = *Zero
     C                   Eval       PNewSpreadSign = *Blanks
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    PBaserate
     C                   PARM                    PBaseFloor
     C                   PARM                    PBseFlrSig
     C                   PARM                    PAllInFlor
     C                   PARM                    PAllInSign
     C                   PARM                    PConSpread
     c                   PARM                    PCNSPSign
     C                   PARM                    PNewSpread
     C                   PARM                    PFinalRate
     C                   PARM                    PNewSpreadSign
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
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      Wrun = 'Y'
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
      *****************************************************************
      /EJECT
      *****************************************************************