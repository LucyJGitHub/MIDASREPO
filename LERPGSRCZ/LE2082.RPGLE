     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Transaction Income Splits Enquiry')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2082 - Transactions Income Splits Enquiry                  *
      *                                                               *
      *  Function:  This module will allow the user to browse the     *
      *             existing Income Splits may it be a loan or a      *
      *             fee                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 10May06               *
      *                 CLE035  *CREATE    Date 22Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CLE035 - LE Enhancements for Nordea Phase 1 Priority 2       *
      *           Income Splits                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas LE Loan Income Splits
     FLETISPL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISP0)
 
      ** Midas LE Fee Income Splits
     FLETISPL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISP1)
 
      ** Midas LE Income Splits Display File
     FLE2082DF  CF   E             WORKSTN SFILE(LE2082S0:#0LREC)
     F                                     SFILE(LE2082S1:#1FREC)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Customer Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Dummy Data Structure (Short) for Access Objects' use
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PSplitType      S              1
 
      ** Access Object Parameters
     D PRetCode        S              7A
     D POption         S              7A
     D PSard           S              6A
     D PKey            S             10A
     D PKyst           S              7A
 
      ** ZEDIT/ZALIGN Parameters
     D ZAlignOK        S              1A   INZ('Y')
     D ZField          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
      ** Working and Key Fields
     D*KLoan****       S              6S 0                                                    CLE148
     D KLoan           S              6A                                                      CLE148
     D*FacCust**       S              6S 0                                                   CSD027A
     D FacCust         S              6A                                                     CSD027A
     D*FacLoan**       S              6S 0                                                    CLE148
     D FacLoan         S              6A                                                      CLE148
     D Facility        S              5S 0
     D FeeSeq          S              2S 0
     D*WFctyLoan       S              6S 0                                                    CLE148
     D WFctyLoan       S              6A                                                      CLE148
     D WFctyLoanFlg    S              1A
     D WTestCharLeft   S              1A
     D WTestCharRight  S              1A
     D OkSelectFlg     S              1A   INZ('Y')
     D OkFeeFlag       S              1A   INZ('Y')
     D NoRecFlag       S              1A   INZ('N')
     D WNum006         S              6P 0                                                    CLE148
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SrInitial
 
     C                   DOU       *INKC = *ON OR PSplitType = 'C'
 
     C                   EXSR      SrBuildSFL
 
     C                   WRITE     LE2082F0
 
     C                   IF        NoRecFlag = 'N'
     C                   SELECT
 
     C                   WHEN      PSplitType = 'L'
     C                   EVAL      #0LREC = 1
     C                   WRITE     LE2082F2
     C                   EXFMT     LE2082C0
 
     C                   WHEN      PSplitType = '1'
     C                   EVAL      #0LREC = 1
     C                   WRITE     LE2082F2
     C                   EXFMT     LE2082C0
 
     C                   WHEN      PSplitType = 'F'
     C                   EVAL      #1FREC = 1
     C                   WRITE     LE2082F2
     C                   EXFMT     LE2082C1
 
     C                   WHEN      PSplitType = '2'
     C                   EVAL      #1FREC = 1
     C                   WRITE     LE2082F2
     C                   EXFMT     LE2082C1
 
     C                   ENDSL
 
     C                   ELSE
 
     C                   SELECT
 
     C                   WHEN      PSplitType = 'L'
     C                   WRITE     LE2082F2
     C                   WRITE     LE2082F1
     C                   EXFMT     LE2082C0
 
     C                   WHEN      PSplitType = '1'
     C                   WRITE     LE2082F2
     C                   WRITE     LE2082F1
     C                   EXFMT     LE2082C0
 
     C                   WHEN      PSplitType = 'F'
     C                   WRITE     LE2082F2
     C                   WRITE     LE2082F1
     C                   EXFMT     LE2082C1
 
     C                   WHEN      PSplitType = '2'
     C                   WRITE     LE2082F2
     C                   WRITE     LE2082F1
     C                   EXFMT     LE2082C1
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   IF        *INKL = *ON
     C                   EVAL      PSplitType = 'C'
     C                   ENDIF
 
     C                   IF        *INKC = *ON AND *IN62 = *ON
     C                   EVAL      PSplitType = 'E'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInitial  - Initialization procedures                       *
      *                                                               *
      *****************************************************************
 
     C     SrInitial     BEGSR
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      *BLANKS       DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     *ENTRY        PLIST
     C                   PARM                    PSplitType
 
     C                   IF        PSplitType = 'L' OR PSplitType = '1'
     C                   EVAL      *IN61 = *ON
     C                   ENDIF
 
     C                   IF        PSplitType = '1' OR PSplitType = '2'
     C                   EVAL      *IN62 = *ON
     C                   ENDIF
 
     C     KFee          KLIST
     C                   KFLD                    FacCust
     C                   KFLD                    FacLoan
     C                   KFLD                    Facility
     C                   KFLD                    FeeSeq
 
     C**********         EVAL      KLoan = *Zeros                                             CLE148
     C                   EVAL      KLoan = *BLANKS                                            CLE148
     C**********         EVAL      FacCust = *Zeros                                          CSD027A
     C                   EVAL      FacCust = *Blanks                                         CSD027A
     C**********         EVAL      FacLoan = *Zeros                                           CLE148
     C                   EVAL      FacLoan = *BLANKS                                          CLE148
     C                   EVAL      Facility = *Zeros
     C                   EVAL      FeeSeq = *Zeros
 
     C                   MOVE      BJMRDT        #0RUNA
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetupKey - Validate Selection Fields and setup Key Fields  *
      *                                                               *
      *****************************************************************
     C     SrSetupKey    BEGSR
 
      ** See if Loan or Fee Income Splits is to be processed
 
     C                   EXSR      SrResetter
 
     C                   IF        PSplitType = 'L' OR PSplitType = '1'
 
      ** If F5 is pressed, clear selection Field
 
     C                   IF        *INKE = *ON
     C                   EVAL      #0LOAN = *BLANKS
     C                   ENDIF
 
      ** Run check to see if selection field is valid
 
     C                   MOVE      *Blanks       ZField
     C                   IF        #0LOAN <> *Blanks
     C                   MOVE      #0LOAN        ZField
     C                   EVAL      ZADEC = 0
     C                   EVAL      ZADIG = 6
     C                   EXSR      SrZAlign
     C                   ENDIF
 
     C                   IF        ZAlignOk = 'N'
     C**********         EVAL      KLoan = *Zeros                                             CLE148
     C                   EVAL      KLoan = *BLANKS                                            CLE148
     C                   EVAL      OkSelectFlg = 'N'
     C                   ELSE
     C                   MOVE      ZField        KLoan
     C                   ENDIF
 
     C     KLoan         SETLL     LETISPL0
 
     C                   ELSE
 
      ** If F5 is pressed, clear selection Field
 
     C                   IF        *INKE = *ON
     C                   EVAL      #1CUST = *BLANKS
     C                   EVAL      #1FACS = *BLANKS
     C                   EVAL      #1FEES = *BLANKS
     C                   ENDIF
 
      ** Run check to see if selection field is valid (#1CNUM)
      ** If the selection field is invalid, blank out Key
 
     C                   MOVE      *Blanks       ZField
     C                   IF        #1CUST <> *Blanks
     C                   MOVE      #1CUST        ZField
     C                   EVAL      ZADEC = 0
     C                   EVAL      ZADIG = 6
     C                   EXSR      SrZAlign
     C                   ENDIF
 
     C                   IF        ZAlignOk = 'N'
     C**********         EVAL      FacCust = *Zeros                                          CSD027A
     C                   EVAL      FacCust = *Blanks                                         CSD027A
     C                   EVAL      OkSelectFlg = 'N'
     C                   ELSE
     C                   MOVE      ZField        FacCust
     C                   ENDIF
 
      ** Run check to see if selection field is valid (#1FACS)
      ** If the selection field is invalid, blank out Key
 
     C                   MOVE      *Blanks       ZField
     C                   IF        #1FACS <> *Blanks
     C                   MOVE      #1FACS        ZField
     C                   EVAL      ZADEC = 0
     C                   EVAL      ZADIG = 6
     C                   EXSR      SrZAlign
     C                   ENDIF
 
     C                   IF        ZAlignOk = 'N'
     C**********         EVAL      FacLoan = *Zeros                                           CLE148
     C                   EVAL      FacLoan = *BLANKS                                          CLE148
     C                   EVAL      Facility = *Zeros
     C                   EVAL      OkSelectFlg = 'N'
     C                   ELSE
 
     C                   MOVE      #1FACS        WTestCharRight
     C                   MOVEL     #1FACS        WTestCharLeft
 
      ** Check whether selection made is for a loan or a facility
 
     C                   IF        WTestCharLeft <> ' '
     C                             AND WTestCharRight <> ' '
     C                   MOVE      ZField        FacLoan
     C                   EVAL      Facility = *Zeros
     C                   ELSE
     C                   MOVE      ZField        Facility
     C**********         EVAL      FacLoan = *Zeros                                           CLE148
     C                   EVAL      FacLoan = *BLANKS                                          CLE148
     C                   ENDIF
 
     C                   MOVE      ZField        WFctyLoan
 
     C                   ENDIF
 
      ** Run check to see if selection field is valid (#1FESQ)
      ** If the selection field is invalid, blank out Key
 
     C                   MOVE      *Blanks       ZField
     C                   IF        #1FEES <> *Blanks
     C                   MOVE      #1FEES        ZField
     C                   EVAL      ZADEC = 0
     C                   EVAL      ZADIG = 2
     C                   EXSR      SrZAlign
     C                   ENDIF
 
     C                   IF        ZAlignOk = 'N'
     C                   EVAL      FeeSeq = *Zeros
     C                   EVAL      OkSelectFlg = 'N'
     C                   ELSE
     C                   MOVE      ZField        FeeSeq
     C                   ENDIF
 
     C**********         IF        FacCust <> *Zeros                                         CSD027A
     C                   IF        FacCust <> *Blanks                                        CSD027A
     C     KFee          SETLL     LETISPL1
     C                   ELSE
     C     *LOVAL        SETLL     LETISPL1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBuildSFL - Build Subfile                                   *
      *                                                               *
      *****************************************************************
 
     C     SrBuildSFL    BEGSR
 
      ** Setup Key for Income Splits Files
 
     C                   EXSR      SrSetupKey
 
      ** If Selection fields were invalid, leave subroutine
 
     C                   IF        OkSelectFlg = 'N'
     C                   EVAL      *IN81 = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build subfile
      ** If No Details exist set Message and exit subroutine
      ** Loop until End-of-File is reached or no matching records left
 
     C                   DOU       %EOF(LETISPL0) OR %EOF(LETISPL1)
 
     C                   IF        PSplitType = 'L' OR PSplitType = '1'
 
     C                   READ      LETISPL0
 
     C                   IF        %EOF(LETISPL0) AND #0LREC <> *Zeros
     C                   ITER
     C                   ENDIF
 
     C                   IF        %EOF(LETISPL0) AND #0LREC = *Zeros
     C                   EVAL      *IN81 = *OFF
     C                   WRITE     LE2082C0
     C                   EVAL      NoRecFlag = 'Y'
     C                   LEAVESR
     C                   ELSE
     C                   EVAL      *IN81 = *ON
     C                   ENDIF
 
     C                   EVAL      #0LNRF = *Blanks
     C                   MOVE      LNRF          #0LNRF
 
     C                   MOVE      ISCN          #0ISCM
 
      ** Format Income Percent Allocation
 
     C                   MOVE      *Blanks       ZField
     C                   MOVE      IPAL          ZField
     C                   EVAL      ZADEC = 9
     C                   EXSR      SrZEdit
     C                   MOVE      ZField        #0IPAL
 
     C                   EVAL      #0LREC = #0LREC + 1
 
     C                   WRITE     LE2082S0
 
     C                   ELSE
 
     C                   READ      LETISPL1
 
     C                   IF        %EOF(LETISPL1) AND #1FREC <> *Zeros
     C                   ITER
     C                   ENDIF
 
     C                   IF        %EOF(LETISPL1) AND #1FREC = *Zeros
     C                   EVAL      *IN81 = *OFF
     C                   WRITE     LE2082C1
     C                   EVAL      NoRecFlag = 'Y'
     C                   ITER
     C                   ENDIF
                                                                                              CLE148
     C                   MOVE      WFctyLoan     WNum006                                      CLE148
 
     C                   SELECT
 
     C**********         WHEN      WFctyLoan = *Zeros AND FeeSeq = *Zeros                     CLE148
     C                   WHEN      WFctyLoan = *BLANKS AND FeeSeq = *Zeros                    CLE148
     C                   EVAL      OkFeeFlag = 'Y'
 
     C**********         WHEN      (WFctyLoan = LNRF OR WFctyLoan = FACL)                     CLE148
     C                   WHEN      (WFctyLoan = LNRF OR WNum006 = FACL)                       CLE148
     C                             AND FeeSeq = *Zeros
     C                   EVAL      OkFeeFlag = 'Y'
 
     C**********         WHEN      WFctyLoan = *Zeros AND FeeSeq = FESQ                       CLE148
     C                   WHEN      WFctyLoan = *BLANKS AND FeeSeq = FESQ                      CLE148
     C                   EVAL      OkFeeFlag = 'Y'
 
     C**********         WHEN      (WFctyLoan = LNRF OR WFctyLoan = FACL)                     CLE148
     C                   WHEN      (WFctyLoan = LNRF OR WNum006 = FACL)                       CLE148
     C                             AND FeeSeq = FESQ
     C                   EVAL      OkFeeFlag = 'Y'
 
     C**********         WHEN      FacCust = *Zeros AND WFctyLoan = *Zeros                   CSD027A
     C**********         WHEN      FacCust = *Blank AND WFctyLoan = *Zeros            CSD027A CLE148
     C                   WHEN      FacCust = *Blank AND WFctyLoan = *BLANKS                   CLE148
     C                             AND FeeSeq = *Zeros
     C                   EVAL      OkFeeFlag = 'Y'
 
     C                   OTHER
     C                   EVAL      OkFeeFlag = 'N'
 
     C                   ENDSL
 
     C                   IF        OkFeeFlag = 'N' AND #1FREC = 0
     C                   EVAL      *IN81 = *OFF
     C                   WRITE     LE2082C1
     C                   EVAL      NoRecFlag = 'Y'
     C                   ITER
     C                   ENDIF
 
     C                   EVAL      *IN81 = *ON
 
     C                   IF        OkFeeFlag = 'Y'
 
     C                   MOVE      CNUM          #1CNUM
 
     C                   EVAL      #1FACL = *Blanks
     C**********         IF        LNRF <> *Zeros                                             CLE148
     C                   IF        LNRF <> *BLANKS                                            CLE148
     C                   MOVE      LNRF          #1FACL
     C                   ELSE
     C                   MOVEL     FACL          #1FACL
     C                   ENDIF
 
     C                   MOVE      FESQ          #1FESQ
     C                   MOVE      ISCN          #1ISCN
 
      ** Format Income Percent Allocation
 
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      IPAL          ZField
     C                   EVAL      ZADEC = 9
     C                   EXSR      SrZEdit
     C                   MOVE      ZField        #1IPAL
 
     C                   EVAL      NoRecFlag = 'N'
     C                   EVAL      #1FREC = #1FREC + 1
     C                   WRITE     LE2082S1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZAlign   - Format Alphanumeric Fields                      *
      *                                                               *
      *****************************************************************
     C     SrZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZField
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZEdit    - Format Numeric Fields                           *
      *                                                               *
      *****************************************************************
     C     SrZEdit       BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM                    ZADEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrResetter - Resets Variables                                *
      *                                                               *
      *****************************************************************
     C     SrResetter    BEGSR
 
      ** Reset flags
     C                   EVAL      OkSelectFlg = 'Y'
     C                   EVAL      ZAlignOK = 'Y'
     C                   EVAL      NoRecFlag = 'N'
 
      ** Reset record counters
     C                   EVAL      #0LREC = *Zeros
     C                   EVAL      #1FREC = *Zeros
 
      ** Clear Subfile of Contents
     C                   EVAL      *IN81 = *OFF
     C                   WRITE     LE2082C0
     C                   WRITE     LE2082C1
     C                   EVAL      *IN81 = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *BLANK
     C                   MOVE      'Y'           RunBefore
     C                   DUMP
     C                   ENDIF
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2003
