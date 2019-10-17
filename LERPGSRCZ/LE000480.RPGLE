     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Identify loans that need EIR calculation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending module                              *
      *                                                               *
      *  LE000480 - Identify loans that need future events for IAS    *
      *                                                               *
      *  Function:  Identify loans for which the IAS processing will  *
      *             need future events. This will allow LE0480 to     *
      *             generate events until end of book only for these  *
      *             loans, reducing therefore disk occupation and cob *
      *             run time.                                         *
      *                                                               *
      *  Component of: LEC0609A                                       *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1063971          Date 06Dec12               *
      *                 CLE148             Date 23Jul12               *
      *                 262545  *CREATE    Date 19Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1063971 - Access hedge details when CAS009 enhancement is  *
      *              switched on.                                     *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  262545 - Reduce cob run time when IAS active                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Loan types/sub-types
     FSDLOANL3  IF   E           K DISK
 
      ** Midas LE Loans by Loan Type/Sub type
     FCLOANL8   IF   E           K DISK
 
      ** Midas LE Effective Interest Rate Detail by Loan number and desc dates
     FLEEIRDL0  IF   E           K DISK
 
      ** Midas LE EIR Amortisation Over Period Detail
     FLEERAPL2  IF   E           K DISK    RENAME(LEERAPD0:LEERAPD2)
 
      ** Midas LE Loans File by Loan/Start select unamort amort sep 'N'
     FLEFEEDLL  IF   E           K DISK    RENAME(LEFEEDF:LEFEEDFL)
 
      ** Midas LE Loans File by Loan/Start select unamort amort sep 'Y'
     FLEFEEDLM  IF   E           K DISK    RENAME(LEFEEDF:LEFEEDFM)
 
     FLE0480PD  O    E             DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Midas SD Bank details ICD file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Midas Hedging ICD file
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)
 
      ** External data structure for Midas SC Switchable features file                     AR1063971
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                               AR1063971
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Parameters
 
     D PRetCode        S              7A
     D POption         S              7A
     D PSard           S              6A                                                   AR1063971
 
      ** Work Fields
 
     D WMode           S              1A   INZ(' ')
     D WFeeFoundF      S              1A
     D WFSeq           S              2S 0
     D WWrite          S              1A
 
     D CAS009          S              1A                                                   AR1063971
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
 
      ** Read Deal Type/Sub Type combinations to index deals file
     C     *LOVAL        SETLL     SDLOANL3
     C                   READ      SDLOANL3
 
     C                   DOW       NOT %EOF(SDLOANL3)
 
     C     KLoanType     SETLL     CLOANL8
     C     KLoanType     READE     CLOANL8
 
      ** Read thru Loans file
     C                   DOW       NOT %EOF(CLOANL8)
 
      ** Skip loans attached to a Yield Curve since these have already been
      ** copied to LE0480PD by the calling CL program (LEC0609A) :
 
     C                   IF        FSYLDC <> *BLANKS
     C     KLoanType     READE     CLOANL8
     C                   ITER
     C                   ENDIF
 
      ** Skip loans valuing before the cut over date and do not have
      ** set Maturity Dates
     C                   IF        FSNLAC > VDAT
     C                             OR  MDAT = 0
     C     KLoanType     READE     CLOANL8
     C                   ITER
     C                   ENDIF
 
     C                   EVAL      WWrite      = 'N'
     C                   EXSR      SrAmortLife
     C                   EXSR      SrAmortPeriod
 
     C     WWrite        IFEQ      'Y'
     C                   WRITE     LE0480PF
     C                   ENDIF
 
     C     KLoanType     READE     CLOANL8
 
     C                   ENDDO
     C                   READ      SDLOANL3
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAmortLife - Process EIR records of valid loans              *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SrChkAmend                                             *
      *                                                               *
      *****************************************************************
 
     C     SrAmortLife   BEGSR
 
      ** Check if an EIRD record exists for the loan
     C     LNRF          SETGT     LEEIRDL0
     C     LNRF          READPE    LEEIRDL0
 
     C                   SELECT
 
     C                   WHEN      NOT %EOF(LEEIRDL0)
     C                             AND EIRCAL = 'Y'
     C                   EVAL      WWrite      = 'Y'
 
     C                   WHEN      NOT %EOF(LEEIRDL0)
     C                             AND EIADJP = 'Y'
     C                   EVAL      WWrite      = 'Y'
 
     C                   OTHER
 
     C                   IF        TOTI <> 0
     C                   EVAL      WWrite      = 'Y'
     C                   ENDIF
 
     C     LNRF          SETLL     LEFEEDLL
     C     LNRF          READE     LEFEEDLL
     C                   DOW       NOT %EOF(LEFEEDLL)
     C                             AND FESTPD <  BJDNWD
     C                   IF        FERECI <> '*'
     C                   EVAL      WWrite      = 'Y'
     C                   ENDIF
     C     LNRF          READE     LEFEEDLL
     C                   ENDDO
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAmortPeriod - Process EIR records of Fees amortised         *
      *                 independently                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrAmortPeriod BEGSR
 
      ** Check if an ERAP record exists for the loan
     C     LNRF          SETLL     LEERAPL2
     C     LNRF          READE     LEERAPL2
 
     C                   DOW       NOT %EOF(LEERAPL2)
 
     C                   IF        EIRCAL = 'Y'
     C                   EVAL      WWrite      = 'Y'
     C                   ENDIF
 
     C     LNRF          READE     LEERAPL2
     C                   ENDDO
 
      ** Check if a Separate Fee is beginning amortisation today
     C     LNRF          SETLL     LEFEEDLM
     C     LNRF          READE     LEFEEDLM
 
     C                   DOW       NOT %EOF(LEFEEDLM)
 
     C                   IF        FESTPD <= BJDNWD
     C                   EVAL      WWrite      = 'Y'
     C                   ENDIF
 
     C     LNRF          READE     LEFEEDLM
     C                   ENDDO
 
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
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = *BLANKS
     C                   EVAL      DbKey = *BLANKS
     C                   EVAL      DbPGM = 'LE000480'
     C                   EVAL      Dbase = *ZERO
     C                   OUT       LDA
 
      ** Access Bank ICD
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      Dbase = 1
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *                                                                                    AR1063971
      ** Check if CAS009 is enabled.                                                       AR1063971
      *                                                                                    AR1063971
     C                   CALL      'AOSARDR0'                                              AR1063971
     C                   PARM      *BLANKS       PRetCode                                  AR1063971
     C                   PARM      '*VERIFY'     POption                                   AR1063971
     C                   PARM      'CAS009'      PSard                                     AR1063971
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR1063971
                                                                                           AR1063971
     C                   IF        PRetCode = *BLANKS                                      AR1063971
     C                   EVAL      CAS009 = 'Y'                                            AR1063971
     C                   ELSE                                                              AR1063971
     C                   EVAL      CAS009 = 'N'                                            AR1063971
     C                   ENDIF                                                             AR1063971
 
      ** Access Object for Hedge ICD
 
     C                   IF        CAS009 = 'Y'                                            AR1063971
 
     C                   CALL      'AOHEDGR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDHEDG        PARM      SDHEDG        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDHEDGPD'
     C                   EVAL      Dbase = 4
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF                                                             AR1063971
 
     C     KLoanType     KLIST
     C                   KFLD                    AYLNTY
     C                   KFLD                    AYLNST
 
     C     KLoanFSeq3    KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    WFSEQ
 
     C                   ENDSR
      *****************************************************************
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
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
