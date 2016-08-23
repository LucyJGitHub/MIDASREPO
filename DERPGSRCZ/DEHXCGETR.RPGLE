     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Hist Ext Ctlr for Generic Transaction')       *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEHXCGETR - Historic Extract Controller for Generic          *
      *              Transactions                                     *
      *                                                               *
      *  Function:  This module processes all of the generic          *
      *             transaction details and calls the generic         *
      *             transactions historic extract to write records to *
      *             the historic extract files.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 22Aug02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CDE005 - Data Export - Reservation ID (Recompiled)           *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
 
     FDEGTRANL1 IF   E           K DISK
     F                                     RENAME(DETRANP0: DEGTRANP0)
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXCPERDD
 
 
     D GTRAN         E DS                  EXTNAME(DEGTRANPD)
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#EXTT            4
     C                   PARM                    I#EOB             1
     C**********         PARM                    I#TREF           20                          CGL029
     C                   PARM                    I#TREF           26                          CGL029
     C                   PARM                    I#MOD             2
      *
      * EXTRACT ALL GENERIC TRANSACTIONS
      * OR EXTRACT A SINGLE GENERIC TRANSACTION
      *
     C     I#EXTT        IFEQ      '*ALL'
     C                   EXSR      EXTALL
     C                   SETON                                        LR
     C                   ELSE
     C                   EXSR      EXTSIN
     C                   ENDIF
      *
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * EXTRACT ALL GENERIC TRANSACTIONS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      DEGTRANP0                              99    *
      *
      * Whilst transactions can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Extract all transactions
      *
     C                   EXSR      EXTRCT
      *
      * Read the next record
      *
     C                   READ      DEGTRANP0                              99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE GENERIC TRANSACTION
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C     GTRANK        KLIST
     C                   KFLD                    I#MOD
     C                   KFLD                    I#TREF
     C     GTRANK        CHAIN     DEGTRANP0                          99        *
      *
      * If the transaction is found
      * extract it
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      EXTRCT
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT
      ********************************************************************
     C     EXTRCT        BEGSR
      *
      * Set the action code
      *
     C                   MOVEL     T#ACTN        W#ACTN
      *
     C                   CALLB     'DEHXTGETR'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM                    W#ACTN            1
     C                   PARM      I#EXTT        W#EXTT            4
     C                   PARM      I#PH          W#PH              1
     C                   PARM      I#EOB         W#EOB             1
     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#HCOD        W#HCOD            5 0
     C                   PARM      I#EXTD        W#EXTD            5 0
     C                   PARM      I#EVCD        W#EVCD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM                    PeriodEDT
     C                   PARM                    GTRAN
     C                   PARM                    Dataarea                                     208221
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#PH + 'GETR' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + GTRAN
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * This is an historic extract
 
     C                   MOVE      'H'           I#PH
 
      * Get Extract control information
 
      /COPY DECPYSRC,DEXTGTCT
 
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
