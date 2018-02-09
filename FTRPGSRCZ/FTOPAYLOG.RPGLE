     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments Support Log Setup')         *
      *****************************************************************
      *                                                               *
      *  Finastra - Funds Transfer ILE Module                         *
      *                                                               *
      *  FTOPAYLOG - Outgoing Payments Support Log Setup Module       *
      *                                                               *
      *  Function:  This module will convert fields of FT Outgoing    *
      *             Payments Details file into screen format to be    *
      *             used in writing records to the log file.          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1090283          Date 10Aug16               *
      *                 CFT157             Date 29Aug14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      *                 CAP084             Date 01Aug03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAP084 - MidasPlus Changes                                   *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  None                                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      * Called by: FTOPAYUPD module                                   *
      *                                                               *
      * Calls:     FTOPAYCVT module                                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------+
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------+
 
      **--------------------------------------------------------------+
      **--------------------------------------------------------------+
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
 
     D OPAYFilFmt    E DS                  EXTNAME(OTPAYDD)
      ** Outgoing Payments in File Format
 
     D OPAYFilFmtx   E DS                  EXTNAME(OTPAYXPD)
      ** Outgoing Payments Extension in File Format
 
     D OPAYScnFmt1   E DS                  EXTNAME(FTOPY1PD)
      ** Outgoing Payments in Screen Format (Level 1 Screen 1)
 
     D OPAYScnFmt1a  E DS                  EXTNAME(FTOPY1APD)
      ** Outgoing Payments in Screen Format (Level 1 Screen 1)
 
     D OPAYScnFmt2   E DS                  EXTNAME(FTOPY2PD)
      ** Outgoing Payments in Screen Format (Level 2 Screen 1)
 
     D OPAYScnFmt3   E DS                  EXTNAME(FTOPY3PD)
      ** Outgoing Payments in Screen Format (Level 2 Screen 1)
 
     D OPAYScnFmt4   E DS                  EXTNAME(FTOPY4PD)
      ** Outgoing Payments in Screen Format (Level 2 Screen 1)
 
     D OPAYScnFmt5   E DS                  EXTNAME(FTOPY5PD)
      ** Outgoing Payments in Screen Format (Level 2 Screen 2)
 
     D OPAYScnFmt6   E DS                  EXTNAME(FTOPY6PD)
      ** Outgoing Payments in Screen Format (Level 2 Screen 3)
 
     D OPAYScnFmt7   E DS                  EXTNAME(FTOPY7PD)
      ** Outgoing Payments in Screen Format (Margin Info)
 
     D ExtDataDS     E DS                  EXTNAME(FTOPEXPD)
      ** IP Extension data
 
     D ValFieldsDS   E DS                  EXTNAME(FTV@OPAYPD)
      ** Outgoing Payments workfields
 
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      ** Funds Transfer Details
      *                                                                                       CER059
     D OPAYScnFmtA   E DS                  EXTNAME(FTOPYAPD)                                  CER059
     D OPAYScnFmtC   E DS                  EXTNAME(FTOPYCPD)                                  CER059
      *                                                                                       CER030
      ** New DS for Extended Narrative Debit                                                  CER030
      *                                                                                       CER030
     D OPAYScnFmt7A  E DS                  EXTNAME(FTOPY7APD)                                 CER030
      *                                                                                       CER030
      ** New DS for Extended Narrative Credit                                                 CER030
      *                                                                                       CER030
     D OPAYScnFmt7B  E DS                  EXTNAME(FTOPY7BPD)                                 CER030
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Transaction details
     D TRANSDTL        S           5800A
 
      ** Additional parameters for CVT
     D PSTATUS         S             24A
     D PMSGR           S              8  0
     D PPART           S              3  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Execute detail processing
 
     C                   EXSR      SRPROC
 
      ** Return to *CALLER
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC   - Detail Processing                                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: FTOPAYCVT - Outgoing Payment Convert Module            *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
      ** Initialise transaction detail field
 
     C                   EVAL      TRANSDTL = *BLANKS
 
      ** Initialise screen fields
 
     C                   EVAL      OPAYScnFmt1 = *BLANK
     C                   EVAL      OPAYScnFmt1a = *BLANK
     C                   EVAL      OPAYScnFmt2 = *BLANK
     C                   EVAL      OPAYScnFmt3 = *BLANK
     C                   EVAL      OPAYScnFmt4 = *BLANK
     C                   EVAL      OPAYScnFmt5 = *BLANK
     C                   EVAL      OPAYScnFmt6 = *BLANK
     C                   EVAL      OPAYScnFmt7 = *BLANK
      *                                                                                       CER030
     C                   EVAL      OPAYScnFmt7A = *BLANKS                                     CER030
     C                   EVAL      OPAYScnFmt7B = *BLANKS                                     CER030
      *                                                                                       CER030
 
      ** Set action code field
 
     C                   EVAL      SACTION = CHTP
 
      ** Convert OP detail from file to screen format
 
     C                   CALLB     'FTOPAYCVT'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    OPAYFilFmt
     C                   PARM                    OPAYFilFmtx
     C                   PARM                    OPAYScnFmt1
     C                   PARM                    OPAYScnFmt1a
     C                   PARM                    OPAYScnFmt2
     C                   PARM                    OPAYScnFmt3
     C                   PARM                    OPAYScnFmt4
     C                   PARM                    OPAYScnFmt5
     C                   PARM                    OPAYScnFmt6
     C                   PARM                    OPAYScnFmt7
     C                   PARM                    OPAYScnFmtA                                  CER059
     C                   PARM                    OPAYScnFmtC                                  CER059
     C                   PARM                    OPAYScnFmt7A                                 CER030
     C                   PARM                    OPAYScnFmt7B                                 CER030
     C                   PARM                    SDFTFR
     C                   PARM                    ValFieldsDS
     C                   PARM                    PSTATUS
     C                   PARM                    PMSGR
     C                   PARM                    PPART
     C                   PARM      *BLANKS       BtnPressed       10                       AR1090283
 
      ** No error on conversion, format TRANSDTL field
 
     C                   IF        RetCodeOut = *BLANK
 
      ** Blank out payment reference
 
     C                   EVAL      SPREF = *BLANKS
 
     C                   EVAL      TRANSDTL = OPAYScnFmt1 + OPAYScnFmt1a +
     C                                        OPAYScnFmt2 + OPAYScnFmt3 +
     C                                        OPAYScnFmt4 + OPAYScnFmt5 +
     C                                        OPAYScnFmt6 + OPAYScnFmt7 +
     C                                        OPAYScnFmt7A +                                  CER030
     C                                        OPAYScnFmt7B +                                  CER030
     C                                        ExtDataDS
     C                   ELSE
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    OPAYFilFmt
     C                   PARM                    OPAYFilFmtx
     C                   PARM                    SDFTFR
     C                   PARM                    ValFieldsDS
     C                   PARM                    TRANSDTL
 
      **--------------------------------------------------------------+
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------+
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
