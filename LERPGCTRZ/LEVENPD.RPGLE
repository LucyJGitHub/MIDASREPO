     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Amortisation End Date')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVSTPD - Validate Amortisation Start Date                   *
      *                                                               *
      *  Function: This function receives a parameter containing      *
      *            Amortisation Start Date (DDENPD) and confirms      *
      *            whether it is a valid entry or not                 *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 262581             Date 16Jan09               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16539A          Date 27Mar08               *
      *                 BUG16787           Date 06Mar08               *
      *                 BUG16539           Date 03Mar08               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS019  *Create    Date 20Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  262581 - Redevelop CAS016 to achieve the following:          *
      *           - if amortising over loan life ensure amortisation  *
      *             period matches loan life;                         *
      *           - improve defaulting of new fields;                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16539A - Changes made in LEVAMRI, LEVENPD, and LEVSTPD    *
      *              if fee code is adjustment to yield and loan is   *
      *              flagged to do amortised cost accounting.         *
      *  BUG16787 - Inconsistency in warning messages for Fees        *
      *  BUG16539 - Error encountered when a linear fee is attached   *
      *             to an amortising type of loan                     *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
      * Customer Loans record CL in file Format
     D                                     PREFIX(CL_)
 
     D TranInPrim    E DS                  EXTNAME(LEFEEMPD)
      * Incoming Transaction
 
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
      ** External DS for Fee Details
 
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      ** External DS for Fee Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   RESET                   ErrorFound
     C                   MOVE      *BLANKS       RetCodeIn
 
     C                   EXSR      VAMEN
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
     C                   PARM                    #MsgID
      *
      ** Field(s) requiring validation
     C                   PARM                    TranInPrim
      *
      ** Information contained in these data structures are needed for validation
     C                   PARM                    SDFEE
     C                   PARM                    SDLOAN
     C                   PARM                    SDBANK
     C                   PARM                    ClilFilFmt
      *
      ** Amortisation Start & End Date
     C                   PARM                    WAStrDat          5 0
     C                   PARM                    WAEndDat          5 0
      *
      ** FEE Start & End Date
     C                   PARM                    WPSTD             5 0
     C                   PARM                    WPEND             5 0
      *
      * OUTPUTS
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      * VAMEN - Validate Amortisation End  Date                       *
      *****************************************************************
     C     VAMEN         BEGSR
 
      *
      ** Entry is allowed only when fee code is adjustment to yield
      ** and loan is flagged to do amortised cost acctg                                    BUG16539A
 
     C**********         IF        (AUADJY <> 'Y')  AND (DDENPD <> *BLANKS)                BUG16539A
     C                   IF        NOT(AUADJY = 'Y' AND AYACAI = 'Y') AND                  BUG16539A
     C                             (DDENPD <> *BLANKS)                                     BUG16539A
     C                   EVAL      #MsgID         = 'LER1202'
     C                   EVAL      ErrorFound     = 'Y'
     C                   EVAL      RetCodeIn      = 'Error'
     C                   LeaveSR
     C                   ENDIF
 
      ** Convert to Midas date format
     C**********         IF        (AUADJY = 'Y' AND DDENPD <> *BLANKS)                     BUG16539
     C**********         IF        (AUADJY = 'Y')                                 BUG16539 BUG16539A
     C                   IF        (AUADJY = 'Y') AND (AYACAI = 'Y')                       BUG16539A
     C                   IF        (DDENPD <> *BLANKS)                                      BUG16539
     C                   MOVE      DDENPD        DATEA
     C                   TESTN                   DATEA                9798
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
      ** Invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   EVAL      #MsgID         = 'LER1204'
     C                   EVAL      ErrorFound     = 'Y'
     C                   EVAL      RetCodeIn      = 'Error'
     C                   LeaveSR
     C                   ELSE
     C                   EVAL      WAEndDat = ZDAYNO
     C                   ENDIF
     C                   ENDIF
 
      *
      ** Entry is mandatory for one off fees and amortise over period is 'Y'
 
     C                   IF        (DDEPON = ' ' AND DDAMRI = 'Y') AND
     C                             (DDENPD = *BLANKS)
     C                   EVAL      #MsgID         = 'LER1209'
     C                   EVAL      ErrorFound     = 'Y'
     C                   EVAL      RetCodeIn      = 'Error'
     C                   LeaveSR
     C                   ENDIF
 
      **********                                                                     BUG16539 262581
      ***Entry*is not allowed if Amortised Over Period is "N"                        BUG16539 262581
      ***Defaulting to maturity date of the loan                                     BUG16539 262581
      **********                                                                     BUG16539 262581
     C**********         IF        (DDAMRI = 'N') AND (DDENPD <> *BLANKS)            BUG16539 262581
     C**********                   AND (CL_MDAT <> WAEndDat)                         BUG16787 262581
     C**********         EVAL      #MsgID         = 'LER1215'                      BUG16539 BUG16787
     C**********         EVAL      #MsgID         = 'LER1221'                        BUG16787 262581
     C**********         EVAL      ErrorFound     = 'Y'                              BUG16539 262581
     C**********         EVAL      RetCodeIn      = 'Warning'                        BUG16539 262581
      **********                                                                     BUG16539 262581
      ***Convert Midas Day number to DDMMYY Format                                   BUG16539 262581
     C**********         CALLB     'ZDATE2'                                          BUG16539 262581
     C**********         PARM      CL_MDAT       ZDAYNO            5 0               BUG16539 262581
     C**********         PARM                    BJDFIN                              BUG16539 262581
     C**********         PARM      *ZEROS        ZDATE             6 0               BUG16539 262581
     C**********         PARM                    ZADATE            7                 BUG16539 262581
      **********                                                                     BUG16539 262581
     C**********         MOVEL     ZDATE         DDENPD                              BUG16539 262581
     C**********         EVAL      WAEndDat       = CL_MDAT                          BUG16539 262581
      **********                                                                     BUG16539 262581
     C**********         LeaveSR                                                     BUG16539 262581
     C**********         ENDIF                                                       BUG16539 262581
                                                                                            BUG16539
      *
      ** Entry must not be beyond maturity date of the loan
 
     C**********         IF        (WAEndDat > CL_MDAT)                                     BUG16539
     C                   IF        (WAEndDat > CL_MDAT) AND (DDENPD <> *BLANKS)             BUG16539
     C                   EVAL      #MsgID         = 'LER1211'
     C                   EVAL      ErrorFound     = 'Y'
     C                   EVAL      RetCodeIn      = 'Error'
     C                   LeaveSR
     C                   ENDIF
      *                                                                                       262581
      ** If Amortising over loan life then amortisation period                                262581
      ** must correspond to loan life                                                         262581
      *                                                                                       262581
     C                   IF        (DDAMRI = 'N') AND (DDENPD <> *BLANKS)                     262581
     C                             AND (CL_MDAT <> WAEndDat)                                  262581
     C                             AND (CL_MDAT <> 0)                                         262581
     C                   EVAL      #MsgID         = 'LER5600'                                 262581
     C                   EVAL      ErrorFound     = 'Y'                                       262581
     C                   EVAL      RetCodeIn      = 'Error  '                                 262581
     C                   LeaveSR                                                              262581
     C                   ENDIF                                                                262581
 
     C                   IF        (DDENPD = *BLANKS)                                       BUG16539
      *
      ** Defaulting
      *
      *
      ***Entry*is*not*allowed*if*Amortised*Over*Period*is*"N"                               BUG16539
      ** If Amortised Over Period is "N"                                                    BUG16539
      ** Defaulting to maturity date of the loan
 
     C                   IF        (DDAMRI = 'N')
     C                             AND (CL_MDAT <> 0)                                         262581
     C**********         EVAL      #MsgID         = 'LER1215'                               BUG16539
     C**********         EVAL      ErrorFound     = 'Y'                                     BUG16539
     C**********         EVAL      RetCodeIn      = 'Warning'                               BUG16539
     C                   EVAL      #MsgID         = 'LER1221'                               BUG16787
     C                   EVAL      ErrorFound     = 'Y'                                     BUG16787
     C                   EVAL      RetCodeIn      = 'Warning'                               BUG16787
      *
      ** Convert Midas Day number to DDMMYY Format
     C                   CALLB     'ZDATE2'
     C                   PARM      CL_MDAT       ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVEL     ZDATE         DDENPD
     C                   EVAL      WAEndDat       = CL_MDAT
 
     C                   LeaveSR
     C                   ENDIF
 
      *
      ** For accruing and amortising fees and amortise period is 'Y'
      ** this field will be defaulted to end date of the fee
 
     C                   IF        (DDAMRI = 'Y' AND DDEPON = 'S') OR
     C                             (DDAMRI = 'Y' AND DDEPON = 'E') OR
     C**********                   (DDAMRI = 'Y' AND DDEPON = 'N')                            262581
     C                             (DDAMRI = 'Y' AND DDEPON = 'N') OR                         262581
     C                             (DDAMRI = 'N' AND CL_MDAT = 0)                             262581
     C                   EVAL      #MsgID         = 'LER1216'
     C                   EVAL      ErrorFound     = 'Y'
     C                   EVAL      RetCodeIn      = 'Warning'
 
     C                   EVAL      DDENPD         = DDEPED
     C                   EVAL      WAEndDat       = WPEND
     C                   LeaveSR
     C                   ENDIF
     C                   ENDIF                                                              BUG16539
                                                                                            BUG16539
      *                                                                                     BUG16539
      ** Start period must not be later than end period                                     BUG16539
                                                                                            BUG16539
     C                   IF        (WAStrDat > WAEndDat) AND                                BUG16539
     C                             (WAStrDat <> *ZEROS) AND                                 BUG16539
     C                             (WAEndDat <> *ZEROS)                                     BUG16539
     C                   EVAL      #MsgID         = 'LER1218'                               BUG16539
     C                   EVAL      ErrorFound     = 'Y'                                     BUG16539
     C                   EVAL      RetCodeIn      = 'Error'                                 BUG16539
     C                   ENDIF                                                              BUG16539
     C                   ENDIF                                                              BUG16539
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
