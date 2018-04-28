     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits change date controller')       *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMLDNICHD - Midas MM Loans/deposits change date controller   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Calls: MM0091   - Midas MM Date Schedule Maintenance         *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL033  *CREATE    Date 10Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL033 - Floating Rate CDs Issued                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
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
 
     D NwDlScnFmt    E DS                  EXTNAME(MMLDNIPD)
      ** New Deal in Screen Format
 
     D PIDTES          DS          3600
      ** Maximum of 600 elements of dates (6A)
 
     D PICONF          DS           600
      ** Maximum of 600 elements of Confirmed Holiday indicators (6A)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Fields
     D MaturityDate    S              5P 0
     D ValueDate       S              5P 0
     D CMDate          S              6S 0
     D CVDate          S              6S 0
 
      ** Notice days converted to Numeric
     D NTCE            S              3S 0
 
      ** Parameter Fields
     D PRetCD          S              7A
     D PMode           S              1A
     D PDealNo         S              6P 0
     D PCurrency       S              6A
     D PMaturityDate   S              5P 0
     D PValueDate      S              5P 0
     D PErrMSgID       S             10A
     D PDealTp         S              2A
     D PRtPymt         S              1A
     D PCTDate         S              5P 0
     D PCVDate         S              5P 0
     D PCMDate         S              5P 0
     D PPassCD         S              1A
 
      ** Zdate2 parameters
     D PZDayNo         S              5P 0
     D PZDatFmt        S              1A
     D PZDate          S              6P 0
     D PZADate         S              7A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Body                                              *
      *                                                               *
      *****************************************************************
 
      ** Convert Midas Days to Date Format (MM/DD/YY or DD/MM/YY)
 
     C                   EVAL      PDealTp = DDTYPE
     C                   EVAL      PPassCd = DDACTN
 
     C     *INLR         DOWEQ     *OFF
 
     C                   IF        DDRCFR  = 'Z'
 
     C                   EVAL      PRtPymt = 'R'
     C                   EVAL      PCTDate = 0
     C                   IF        DDRCDT <> *BLANKS
     C                   MOVEL     DDRCDT        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZDATE             6 0
     C                   PARM                    BJDFIN
     C                   PARM      0             ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        PCTDate
     C                   ENDIF
     C                   EXSR      SRSCHED
 
     C                   ENDIF
 
     C                   IF        DDIPFQ  = 'Z'
     C                             AND (PRetCd = *BLANKS)
 
     C                   EVAL      PRtPymt = 'P'
     C                   EVAL      PCTDate = 0
     C                   IF        DDNDAT <> *BLANKS
     C                   MOVEL     DDNDAT        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZDATE
     C                   PARM                    BJDFIN
     C                   PARM      0             ZDAYNO
     C                   Z-ADD     ZDAYNO        PCTDate
     C                   ENDIF
     C                   EXSR      SRSCHED
 
      ** If <F12>, then previous screen
     C     PRetCd        IFEQ      'USR0790'
     C                   ITER
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   ENDDO
 
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRSCHED - Call Date Schedule Maintenance Screen              *
      *                                                              *
      ****************************************************************
     C     SRSCHED       BEGSR
 
     C                   CALL      'MM0091'
     C                   PARM                    PDealNo
     C                   PARM                    PDealTp
     C                   PARM                    PRtPymt
     C                   PARM                    PCTDate
     C                   PARM      PValueDate    PCVDate
     C                   PARM      PMaturityDate PCMDate
     C                   PARM                    PCurrency
     C                   PARM                    PPassCd
     C                   PARM      *BLANKS       PIDTES
     C                   PARM      *BLANKS       PICONF
     C                   PARM                    PRetCd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return code
     C                   PARM                    PRetCD
      ** Mode
     C                   PARM                    PMode
      ** Deal screen format
     C                   PARM                    NwDLScnFmt
      ** Deal number
     C                   PARM                    PDealNo
      ** Currency
     C                   PARM                    PCurrency
      ** Maturity date
     C                   PARM                    PMaturityDate
      ** Value date
     C                   PARM                    PValueDate
      ** Date Format (M or D)
     C                   PARM                    BJDFIN            1
      ** Error Message
     C                   PARM                    PErrMsgID
 
     C                   ENDSR
      *****************************************************************
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
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
