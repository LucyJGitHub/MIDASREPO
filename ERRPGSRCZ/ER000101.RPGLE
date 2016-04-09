     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas @24 KWG workfile creation')                      *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000101 - Midas @24 KWG data extraction                     *
      *                                                               *
      *  Function : This program reads the Institute account records, *
      *             fills the workfile and calles the transmission    *
      *             file creation.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER068             Date 25Feb14               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG26298           Date 06Oct09               *
      *                 BUG24101           Date 27May09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER068 - Upgrade CER047 to be compatible with BaFin 3.2.2    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26298 - Enable export to Meridian                         *
      *  BUG24101 - KWG Extract does not capture non-account holders  *
      *             (Recompile)                                       *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *     80        Read to ERACEXPP caused EOF                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRClrf - Clear workfile                                      *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** ERACEXL1 - Midas @24 KWG account record by account number
      *
     FERACEXL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** ERACEXL2 - Midas @24 KWG account record by account number
      *
     FERACEXL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ERACEXD0:ERACEXD1)
     F                                     USROPN
      *
      ** ERACEPL0 - Midas @24 KWG account record persons by account
      *
     FERACEPL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** ERCRCDPD - Record type 'C' workfile
      *
     FERCRCDPD  UF A F 2000        DISK    INFSR(*PSSR)
     F                                     USROPN
      *                                                                                     BUG26298
      ** ERCRBTPD - Midas @24 KWG transmission file                                         BUG26298
      *                                                                                     BUG26298
     FERCRBTPD  O    E             DISK    INFSR(*PSSR)                                     BUG26298
     F                                     USROPN                                           BUG26298
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the DB error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External data structures for C-Record file - BANKVERLAG
      *
     D ERCRCDB       E DS                  EXTNAME(ERCRCBPD) PREFIX(B)
      *
      ** External data structures for C-Record file - T-SYSTEMS
      *
     D ERCRCDT       E DS                  EXTNAME(ERCRCTPD) PREFIX(T)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Entry Parameters
      *
     D  PBkn           S              1A
     D  PUtp           S              1A
     D  PRtnCde        S              1P 0
     D  PCurFNR        S              8P 0
      *
      ** Parameters For PLIST PLV10H2
      *
     D  PInlr          S              1A
     D  PFnr           S              8P 0
      *
      ** Variables For Output Specification
      *
     D  CRcdData       S           2000A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Declaration of Input Specification
      *
     IERCRCDPD  NS
     I                                  1 2000  CRcdData
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Main processing
      *
      ** Read Institute Account record
      *
     C                   DOU       *IN80
     C                   IF        PCurFNR = 0
     C                   READ      ERACEXD0                               80
     C                   ELSE
     C     PCurFNR       READE     ERACEXD1                               80
     C                   ENDIF
      *
      ** Clear and open workfile
      *
     C                   EXSR      SRClrf
      *
      ** Write Institute Account record to workfile, if found
      *
     C                   IF        NOT(*IN80)
      *
      ** Set header values
      *
     C                   EVAL      BF1CRTP = 'C'
     C                   EVAL      TF1CRTP = 'C'
     C                   EVAL      F1CRTP = 'C'                                             BUG26298
     C                   EVAL      BF1CDTP = F12DTP
     C                   EVAL      TF1CDTP = F12DTP
     C                   EVAL      F1CDTP = F12DTP                                          BUG26298
     C                   EVAL      BF1CATP = F12ATP
     C                   EVAL      F1CATP = F12ATP                                          BUG26298
     C                   EVAL      BF1CACC = %TRIM(F12ACC)
     C                   EVAL      TF1CACC = %TRIM(F12ACC)
     C                   EVAL      F1CACC = %TRIM(F12ACC)                                   BUG26298
     C                   EVAL      BF1CCCY = F12CCY
     C                   EVAL      TF1CCCY = %TRIM(F12CCY)
     C                   EVAL      F1CCCY = %TRIM(F12CCY)                                   BUG26298
     C                   EVAL      BF1CBLZ = F12BLZ
     C                   EVAL      TF1CBLZ = %TRIM(F12BLZ)
     C                   EVAL      F1CBLZ = F12BLZ                                          BUG26298
     C                   EVAL      BF1CPCD = F12PCD
     C                   EVAL      TF1CPCD = %TRIM(F12PCD)
     C                   EVAL      F1CPCD = F12PCD                                          BUG26298
     C                   EVAL      BF1CREF = F12REF
     C                   EVAL      TF1CREF = %TRIM(F12REF)
     C                   EVAL      F1CREF = F12REF                                          BUG26298
     C                   EVAL      TF1REFN = F12RFN                                           CER068
     C                   MOVE      F12CDT        BF1CCDT
     C                   MOVE      F12CDT        TF1CCDT
     C                   MOVE      F12CDT        F1CCDT                                     BUG26298
     C                   MOVE      F12VDT        BF1CVDT
     C                   MOVE      F12VDT        TF1CVDT
     C                   MOVE      F12VDT        F1CVDT                                     BUG26298
     C                   MOVE      F12VTM        BF1CVTM
     C                   MOVE      F12VTM        F1CVTM                                     BUG26298
      *
     C                   IF        F12DDT <> 0
      *
     C                   EVAL      %LEN(BF1CDDT) = 8
     C                   EVAL      %LEN(TF1CDDT) = 8
     C                   MOVEL     F12DDT        BF1CDDT
     C                   MOVEL     F12DDT        TF1CDDT
     C                   MOVEL     F12DDT        F1CDDT                                     BUG26298
      *
     C                   ELSE
      *
     C                   EVAL      BF1CDDT = ''
     C                   EVAL      TF1CDDT = ''
     C                   EVAL      F1CDDT = ''                                              BUG26298
      *
     C                   ENDIF
      *
      ** Set detail values
      *
     C     KLerac        SETLL     ERACEPL0
     C                   DOU       %EOF
      *
     C     KLerac        READE     ERACEPD0
      *
     C                   IF        NOT(%EOF)
      *
     C                   EVAL      BF1CPTP = F13PTP
     C                   EVAL      TF1CPTP = F13PTP
     C                   EVAL      F1CPTP = F13PTP                                          BUG26298
     C                   EVAL      BF1CSNM = %TRIM(F13SNM)
     C                   EVAL      TF1CSNM = %TRIM(F13SNM)
     C                   EVAL      F1CSNM = %TRIM(F13SNM)                                   BUG26298
     C                   EVAL      BF1CFNM = %TRIM(F13FNM)
     C                   EVAL      TF1CFNM = %TRIM(F13FNM)
     C                   EVAL      F1CFNB = %TRIM(F13FNM)                                   BUG26298
     C                   EVAL      F1CFNT = %TRIM(F13FNM)                                   BUG26298
     C                   EVAL      BF1CSTR = %TRIM(F13STR)
     C                   EVAL      TF1CSTR = %TRIM(F13STR)
     C                   EVAL      F1CSTB = %TRIM(F13STR)                                   BUG26298
     C                   EVAL      F1CSTT = %TRIM(F13STR)                                   BUG26298
     C                   EVAL      BF1CLOC = %TRIM(%TRIM(F13ZIP) +
     C                             ' ' + %TRIM(F13TWN) +
     C                             ' ' + %TRIM(F13CTY))
     C                   EVAL      F1CLOC = %TRIM(%TRIM(F13ZIP) +                           BUG26298
     C                             ' ' + %TRIM(F13TWN) +                                    BUG26298
     C                             ' ' + %TRIM(F13CTY))                                     BUG26298
     C                   EVAL      TF1CZIP = %TRIM(F13ZIP)
     C                   EVAL      TF1CTWN = %TRIM(F13TWN)
     C                   EVAL      TF1CCTY = %TRIM(F13CTY)
     C                   EVAL      F1CZIP = %TRIM(F13ZIP)                                   BUG26298
     C                   EVAL      F1CTWN = %TRIM(F13TWN)                                   BUG26298
     C                   EVAL      F1CCTY = %TRIM(F13CTY)                                   BUG26298
      *
     C                   IF        F13BDT <> 0
      *
     C                   EVAL      %LEN(BF1CBDT) = 8
     C                   EVAL      %LEN(TF1CBDT) = 8
     C                   MOVEL     F13BDT        BF1CBDT
     C                   MOVEL     F13BDT        TF1CBDT
     C                   MOVEL     F13BDT        F1CBDT                                     BUG26298
      *
     C                   ELSE
      *
     C                   EVAL      BF1CBDT = ''
     C                   EVAL      TF1CBDT = ''
     C                   EVAL      F1CBDT = ''                                              BUG26298
      *
     C                   ENDIF
      *
     C                   SELECT
      *
     C                   WHEN      PBkn = 'B'
     C                   EVAL      CRcdData  = ERCRCDB
     C                   EVAL      F1BIND = 'B'                                             BUG26298
     C                   WHEN      PBkn = 'T'
     C                   EVAL      CRcdData  = ERCRCDT
     C                   EVAL      F1BIND = 'T'                                             BUG26298
      *
     C                   ENDSL
     C                   EXCEPT    CRcdAdd
     C                   WRITE     ERCRBTD0                                                 BUG26298
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Call transmission creation program
      *
     C                   CLOSE     ERCRCDPD
     C                   CALLB     'ER000102'
     C                   PARM                    PBkn
     C                   PARM                    PUtp
     C                   PARM      *IN80         PInlr
     C                   PARM      PCurFNR       PFnr
     C                   PARM                    PRtnCde
     C                   IF        PRtnCde <> 0
     C                   LEAVE
     C                   ENDIF
      *
      ** Update Institute Account record, if found
      *
     C                   IF        NOT(*IN80) and PCurFNR = 0
     C                   EVAL      F12SNT = 'Y'
     C                   EVAL      F12FNR = PFnr
     C                   UPDATE    ERACEXD0
     C                   ENDIF
      *
      ** Read next Institute Account record
      *
     C                   ENDDO
      *
      ** Close files
      *
     C                   CLOSE     ERACEPL0
     C                   IF        PCurFNR = 0
     C                   CLOSE     ERACEXL1
     C                   ELSE
     C                   CLOSE     ERACEXL2
     C                   ENDIF
     C                   CLOSE     ERCRBTPD                                                 BUG26298
      *
      ** End the program
      *
     C                   SETON                                        LR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrf - Clear workfile                                      *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRClrf        BEGSR
      *
      ** Clear workfile
      *
     C                   OPEN      ERCRCDPD
     C                   READ      ERCRCDPD
     C                   DOW       NOT(%EOF)
      *
     C                   EXCEPT    CRcdDel
     C                   READ      ERCRCDPD
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** *Entry Parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    PBkn
     C                   PARM                    PUtp
     C                   PARM                    PCurFNR
     C                   PARM                    PRtnCde
      *
     C     PLV10H2       PLIST
     C                   PARM                    PBkn
     C                   PARM                    PUtp
     C                   PARM      *IN80         PInlr
     C                   PARM      PCurFNR       PFnr
     C                   PARM                    PRtnCde
      *
     C     KLerac        KLIST
     C                   KFLD                    F12ACC
     C                   KFLD                    F12REF
     C                   KFLD                    F12VDT
     C                   KFLD                    F12VTM
      *
      ** Open files
      *
     C                   IF        PCurFNR = 0
     C                   OPEN      ERACEXL1
     C                   ELSE
     C                   OPEN      ERACEXL2
     C     PCurFNR       SETLL     ERACEXD1
     C                   ENDIF
     C                   OPEN      ERACEPL0
     C                   OPEN      ERCRBTPD                                                 BUG26298
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Program, module and procedure names for DB error processing.
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Output Specification
      *
     OERCRCDPD  EADD         CRcdAdd
     O                       CRcdData
      *
     OERCRCDPD  EDEL         CRcdDel
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
