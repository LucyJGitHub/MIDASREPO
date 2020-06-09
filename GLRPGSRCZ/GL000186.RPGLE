     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Multicash narratives Maintenance')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000186 - Multicash Narrative Maintenance                   *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26088A          Date 10Oct09               *
      *                 BUG25438           Date 25Aug09               *
      *                 BUG24257           Date 10Jun09               *
      *                 BUG23742*CREATE    Date 09May09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26088A - Batch was accepted with 2 EN tabs filled in      *
      *              webfaced screen                                  *
      *  BUG25438 - Batch was accepted when 2 EN tabs are filled out  *
      *  BUG24257 - Incorrect "Write" condition on MTCash Narr File   *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  USE OF INDICATORS.                                           *
      *                                                               *
      *    28         Protect Input Fields - Enquiry Mode             *
      *    29         Check Indicator                                 *
      *    30         Error Indicator                                 *
      *    31 - 52    Error Indicator Multicash Narr1 - Narr 22       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRMove - Move File Fields to Screen Fields                    *
      * SRFormat - Format Fields to Screen Fields                     *
      * SRValidate - Validate Additional Information                  *
      * SRUpdate - Update PF/GLMNARPD                                 *
      * SRDelete - Delete from PF/GLMNARPD if amend and additional    *
      *            information fields are blanks                      *
      * SRSndErr - Send Error Message                                 *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
      ** Multicash narrative Maintenance1 Display File
      *
     FGL000186DFCF   E             WORKSTN INFSR(*PSSR) USROPN
      *
      ** Midas GL MultiCash Narratives File - Rtv Indx
      *
     FGLMNARL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLMNARD0:GLMNARD1)
      *
      ** Midas GL MultiCash Narratives File - Update Index 2
      *
     FGLMNARL5  UF A E           K DISK    INFSR(*PSSR) COMMIT
      *
      ** Midas GL Network Accounts - MT94x
      *
     FGLNW94L11 IF   E           K DISK
      *
      ** Midas Network Transaction code
      *
     FGLNW94L8  IF   E           K DISK    RENAME(GLNW94D0:GLNW94D1)
      *                                                                                    BUG26088A
      ** Midas GL Journal Entry - Additional Information                                   BUG26088A
      *                                                                                    BUG26088A
     FGLJENXL2  IF   E           K DISK    INFSR(*PSSR)                                    BUG26088A
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External data structure for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Network details record format data structure
      *
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      *
      ** Long Access Object Data Structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** First DS for Access Programs, Short Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Data Structure for Screen Fields (it's size equal to glmnarpd)
      *
     D #1DBRC          DS           800
     D PDetails        DS          1000
      *
      ** Multicash Narrative Data Structure
      *
     D @1DBRC        E DS                  EXTNAME(GLMNARL5)
      *
     D PPostDetails    DS           119
     D  DDBANB                 1      3
     D  DDITNB                 4      6
     D  WBranch                7      9
     D  WCNum                 10     15
     D  WCurr                 16     18
     D  WACodeQQ              19     22
     D  WASeq                 23     24
     D  DDRACN                25     34
     D  DDPTAM                35     48
     D  DDDCIN                49     49
     D  DDNRDC                50     79
     D  WValDate              80     85
     D  DDTRTY                86     90
     D  DDTSTY                91    100
     D  DDCQNB               101    108
     D  WACode               109    118
     D  WEdtind              119    119
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Input/Output Parameters
      *
     D PRetCodeIn      S              7A
     D PAdditional1    S              1A
     D PMode           S              1A
     D PCancel         S              1A
     D PExit           S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D PInputDate      S              5  0
     D PAInput         S              7A
     D PNInput         S              6  0
     D PDate           S              6A
     D PDateFormat     S              1A
     D PError          S              1A
     D PBranch         S              3A
     D*PCustNum*       S              6  0                                                    CER059
     D PCustNum        S              6A                                                      CER059
     D PCcy            S              3A
     D PAccd           S             10A
     D PAcsq           S              2S 0
     D PReturnCode     S             10A
     D PPOSTDATE       S              5P 0
      *
      ** Work Fields
      *
     D WPos            S              4P 0
     D WRun            S              1A
     D WError          S              1A
     D WAllow          S              1A                                                    BUG25438
     D WValAddInfoFlg  S              1A                                                   BUG26088A
     D WDetails        S           1000                                                    BUG26088A
      *
     D ScnField        S             10A
      *
      ** Index for arrays of error message ids, etc.
      *
     D Idx             S              3P 0
      *
      ** Fields used for Message Files
      *
     D PMsgFile        S             10A   INZ('GLUSRMSG')
     D PMsgID          S              7A
     D PZaPgrl         S              5A   INZ('*SAME')
     D PMsgDta         S            132A
     D PZaMstp         S              7A   INZ(*BLANKS)
     D PZaPgm          S             10A   INZ('GL000186')
      *
      ** Key List Parameters
      *
     D KBrca           S                   LIKE(N4BRCA)
     D KCNum           S                   LIKE(N4CNUM)
     D KCcy            S                   LIKE(N4CCY)
     D KAccd           S                   LIKE(N4ACCD)
     D KAcsq           S                   LIKE(N4ACSQ)
     D KAPODT          S              5P 0
     D KABANB          S              3A
     D KAITNB          S              3P 0
      * Key List for GLJENXL2                                                              BUG26088A
     D KBTNB           S              3A                                                   BUG26088A
     D KBINB           S              3P 0                                                 BUG26088A
      *
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
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C                   OPEN      GL000186DF
 
     C                   SELECT
      *
      ** Validate only
      *
     C                   WHEN      PMode = 'V'
     C                   EXSR      SRMove
     C                   EXSR      SRValidate
      *
     C                   WHEN      PMode = 'U'
     C                   EXSR      SRValidate
     C                   IF        WError = 'N' AND
     C**********                   (DDEX1 <> *BLANKS OR                                     BUG24257
     C**********                   DDEX2 <> *BLANKS)                                        BUG24257
     C                             PDetails <> *BLANKS                                      BUG24257
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
     C                   IF        WError = 'N' AND
     C**********                   (DDEX1 = *BLANKS AND                                     BUG24257
     C**********                   DDEX2 = *BLANKS)                                         BUG24257
     C                             PDetails = *BLANKS                                       BUG24257
     C                   EXSR      SRDelete
     C                   ENDIF
      *
      ** Otherwise, execute maintenance display file
      *
     C                   OTHER
      *
     C                   IF        PMode = 'E' OR
     C                             WEdtind = 'N'
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN29 = *ON
     C                   ELSE
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN29 = *OFF
     C                   ENDIF
      *
      ** IF WEdtind = 'E' Display Error Meesage that entry not allowed
      ** since data already entered in 6x65 details.
      *
     C                   EXSR      SRMove                                                   BUG25438
     C                   IF        WEdtind = 'N'
     C                   IF        WAllow = 'Y'                                             BUG25438
     C                   EVAL      *IN28 = *OFF                                             BUG25438
     C                   ELSE                                                               BUG25438
     C                   EVAL      PMsgID = 'GLX1002'
     C                   EXSR      SRSndErr
     C                   ENDIF                                                              BUG25438
     C                   ENDIF
      *
     C                   EXSR      SRFormat
     C**********         EXSR      SRMove                                                   BUG25438
      *
      ** For Initial Run
      *
     C                   EVAL      WError = 'Y'
      *
     C                   DOW       WError = 'Y' OR *INKE = *ON
      *
     C                   EVAL      WError = 'N'
     C                   EVAL      *INKE = *OFF
      *
     C                   WRITE     GL000186C0
     C                   WRITE     GL000186D0
     C                   WRITE     GL000186F0
      *
     C                   READ      GL000186D0                             99
      *
     C                   CALL      'ZA0250'
     C                   MOVEA     '000000000000'*IN(31)
     C                   MOVEA     '0000000000'  *IN(43)
      *
     C                   IF        PMode = 'M' AND *INKC = *OFF AND
     C                             *INKE = *OFF AND *INKL = *OFF
     C                   EXSR      SRValAddInfo                                            BUG26088A
     C                   EXSR      SRValidate
      *
     C                   IF        WError = 'N' AND
     C**********                   (DDEX1 <> *BLANKS OR                                     BUG24257
     C**********                   DDEX2 <> *BLANKS)                                        BUG24257
     C                             PDetails <> *BLANKS                                      BUG24257
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
     C                   IF        WError = 'N' AND
     C**********                   (DDEX1 = *BLANKS AND                                     BUG24257
     C**********                   DDEX2 = *BLANKS)                                         BUG24257
     C                             PDetails = *BLANKS                                       BUG24257
     C                   EXSR      SRDelete
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Refresh requested
      *
     C                   IF        *INKE = *ON
     C                   EXSR      SRFormat
     C                   EXSR      SRMove
     C                   ENDIF
      *
      ** If Cancel or Exit requested
      *
     C                   IF        *INKL = *ON
      *
     C**********         IF        (DDEX1 <> *BLANKS OR                                     BUG24257
     C**********                   DDEX2 <> *BLANKS)                                        BUG24257
     C                   IF        PDetails <> *BLANKS                                      BUG24257
     C                   EVAL      PAdditional1 = 'Y'
     C                   ENDIF
      *
     C                   EVAL      PCancel = '1'
     C                   ENDIF
      *
     C                   IF        *INKC = *ON
     C                   EVAL      PExit = '1'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSL
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Move File Fields to Screen Fields                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRMove        BEGSR
      *
     C                   EVAL      KAPODT = PPostDate
     C                   EVAL      KABANB = DDBANB
     C                   MOVEL     DDITNB        KAITNB
     C                   EVAL      WAllow = 'N'                                             BUG25438
      *
     C     KJENX         CHAIN     GLMNARL3
     C                   IF        %FOUND(GLMNARL3)
     C                   EVAL      DDEX1 = BAEX1
     C                   EVAL      DDEX2 = BAEX2
     C                   EVAL      DDEX3 = BAEX3
     C                   EVAL      DDEX4 = BAEX4
     C                   EVAL      DDEX5 = BAEX5
     C                   EVAL      DDEX6 = BAEX6
     C                   EVAL      DDEX7 = BAEX7
     C                   EVAL      DDEX8 = BAEX8
     C                   EVAL      DDEX9 = BAEX9
     C                   EVAL      DDEX10 = BAEX10
     C                   EVAL      DDEX11 = BAEX11
     C                   EVAL      DDEX12 = BAEX12
     C                   EVAL      DDEX13 = BAEX13
     C                   EVAL      DDEX14 = BAEX14
     C                   EVAL      DDEX15 = BAEX15
     C                   EVAL      DDEX16 = BAEX16
     C                   EVAL      DDEX17 = BAEX17
     C                   EVAL      DDEX18 = BAEX18
     C                   EVAL      DDEX19 = BAEX19
     C                   EVAL      DDEX20 = BAEX20
     C                   EVAL      DDEX21 = BAEX21
     C                   EVAL      DDEX22 = BAEX22
     C                   IF        WEdtind = 'N'                                            BUG25438
     C                   EVAL      WAllow = 'Y'                                             BUG25438
     C                   ENDIF                                                              BUG25438
     C                   ELSE
     C                   EVAL      DDEX1 = *BLANKS
     C                   EVAL      DDEX2 = *BLANKS
     C                   EVAL      DDEX3 = *BLANKS
     C                   EVAL      DDEX4 = *BLANKS
     C                   EVAL      DDEX5 = *BLANKS
     C                   EVAL      DDEX6 = *BLANKS
     C                   EVAL      DDEX7 = *BLANKS
     C                   EVAL      DDEX8 = *BLANKS
     C                   EVAL      DDEX9 = *BLANKS
     C                   EVAL      DDEX10 = *BLANKS
     C                   EVAL      DDEX11 = *BLANKS
     C                   EVAL      DDEX12 = *BLANKS
     C                   EVAL      DDEX13 = *BLANKS
     C                   EVAL      DDEX14 = *BLANKS
     C                   EVAL      DDEX15 = *BLANKS
     C                   EVAL      DDEX16 = *BLANKS
     C                   EVAL      DDEX17 = *BLANKS
     C                   EVAL      DDEX18 = *BLANKS
     C                   EVAL      DDEX19 = *BLANKS
     C                   EVAL      DDEX20 = *BLANKS
     C                   EVAL      DDEX21 = *BLANKS
     C                   EVAL      DDEX22 = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      #1DBRC = @1DBRC
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFormat - Format Fields to Screen Fields                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRFormat      BEGSR
      *
      ** Format Account Number
      *
     C                   EVAL      DDACCN = WBranch + WCNum + WCurr +
     C                                      WACode + WASeq
      *
      ** Format Value Date to DDMMMYY
      *
     C                   MOVE      WValDate      PDate
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM                    PInputDate
     C                   PARM                    PDateFormat
     C                   PARM      *BLANKS       PError
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    PInputDate
     C                   PARM                    PDateFormat
     C                   PARM      *ZEROS        PNInput
     C                   PARM      *BLANKS       PAInput
      *
     C                   EVAL      DDVLDT = PAInput
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Additional Information                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
      *
      ** Call Extended Narrative Validation Program
      *
     C                   EVAL      PBranch = WBranch
     C                   MOVEL     WCNum         PCustNum
     C                   EVAL      PCcy = WCurr
     C                   EVAL      PAccd = WACode
     C                   MOVEL     WASeq         PAcsq
      *
      ** Pass extended narratives
      *
     C                   EVAL      PDetails = DDEX1 + DDEX2 + DDEX3+
     C                             DDEX4 + DDEX5 + DDEX6 + DDEX7+
     C                             DDEX8 + DDEX9 + DDEX10 + DDEX11+
     C                             DDEX12 + DDEX13 + DDEX14 + DDEX15+
     C                             DDEX16 + DDEX17 + DDEX18 + DDEX19+
     C                             DDEX20 + DDEX21 + DDEX22
      *                                                                                     BUG25438
     C                   IF        WEdtind = 'N' AND                                        BUG25438
     C                             PDetails <> *BLANKS                                      BUG25438
     C                             OR WValAddInfoFlg = 'Y' AND                             BUG26088A
     C                             PDetails <> *BLANKS                                     BUG26088A
     C                   EVAL      WError = 'Y'                                             BUG25438
     C                   EVAL      PMsgID = 'USR9375'                                       BUG25438
     C                   EXSR      SRSndErr                                                 BUG25438
     C                   ELSE                                                               BUG25438
      *
     C                   CALLB     'GLVEXTNARR'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM                    PBranch
     C                   PARM                    PCustNum
     C                   PARM                    PCcy
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PDetails
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   IF        PReturnCode <> *Blanks
     C                   EVAL      WError = 'Y'
     C                   IF        PMode <> 'V'
     C                   EXSR      SRChkFld
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF                                                              BUG25438
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update PF/GLMNARPD                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate      BEGSR
      *
     C                   EVAL      KAPODT = PPostDate
     C                   EVAL      KABANB = DDBANB
     C                   MOVEL     DDITNB        KAITNB
      *
     C     KJENX         CHAIN     GLMNARL5
     C                   IF        %FOUND(GLMNARL5)
      *
      ** Update File
      *
     C                   EVAL      BAEX1 = DDEX1
     C                   EVAL      BAEX2 = DDEX2
     C                   EVAL      BAEX3 = DDEX3
     C                   EVAL      BAEX4 = DDEX4
     C                   EVAL      BAEX5 = DDEX5
     C                   EVAL      BAEX6 = DDEX6
     C                   EVAL      BAEX7 = DDEX7
     C                   EVAL      BAEX8 = DDEX8
     C                   EVAL      BAEX9 = DDEX9
     C                   EVAL      BAEX10 = DDEX10
     C                   EVAL      BAEX11 = DDEX11
     C                   EVAL      BAEX12 = DDEX12
     C                   EVAL      BAEX13 = DDEX13
     C                   EVAL      BAEX14 = DDEX14
     C                   EVAL      BAEX15 = DDEX15
     C                   EVAL      BAEX16 = DDEX16
     C                   EVAL      BAEX17 = DDEX17
     C                   EVAL      BAEX18 = DDEX18
     C                   EVAL      BAEX19 = DDEX19
     C                   EVAL      BAEX20 = DDEX20
     C                   EVAL      BAEX21 = DDEX21
     C                   EVAL      BAEX22 = DDEX22
     C                   UPDATE    GLMNARD0
      *
     C                   EVAL      PAdditional1 = 'Y'
     C                   EVAL      #1DBRC = @1DBRC
      *
      ** Write New Record
      *
     C                   ELSE
     C**********         IF        DDEX1 <> *BLANKS OR                                      BUG24257
     C**********                   DDEX2 <> *BLANKS                                         BUG24257
     C                   IF        PDetails <> *BLANKS                                      BUG24257
     C                   EVAL      BAPODT = BJRDNB
     C                   EVAL      BABANB = DDBANB
     C                   MOVEL     DDITNB        BAITNB
     C                   EVAL      BAEX1 = DDEX1
     C                   EVAL      BAEX2 = DDEX2
     C                   EVAL      BAEX3 = DDEX3
     C                   EVAL      BAEX4 = DDEX4
     C                   EVAL      BAEX5 = DDEX5
     C                   EVAL      BAEX6 = DDEX6
     C                   EVAL      BAEX7 = DDEX7
     C                   EVAL      BAEX8 = DDEX8
     C                   EVAL      BAEX9 = DDEX9
     C                   EVAL      BAEX10 = DDEX10
     C                   EVAL      BAEX11 = DDEX11
     C                   EVAL      BAEX12 = DDEX12
     C                   EVAL      BAEX13 = DDEX13
     C                   EVAL      BAEX14 = DDEX14
     C                   EVAL      BAEX15 = DDEX15
     C                   EVAL      BAEX16 = DDEX16
     C                   EVAL      BAEX17 = DDEX17
     C                   EVAL      BAEX18 = DDEX18
     C                   EVAL      BAEX19 = DDEX19
     C                   EVAL      BAEX20 = DDEX20
     C                   EVAL      BAEX21 = DDEX21
     C                   EVAL      BAEX22 = DDEX22
     C                   WRITE     GLMNARD0
      *
     C                   EVAL      PAdditional1 = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete from PF/GLMNARPD if amend and additional    *
      *            information1 fields are blanks                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
      *
     C                   EVAL      KAPODT = PPostDate
     C                   EVAL      KABANB = DDBANB
     C                   MOVEL     DDITNB        KAITNB
      *
     C     KJENX         CHAIN     GLMNARL5
     C                   IF        %FOUND(GLMNARL5)
      *
      ** Delete File
      *
     C                   DELETE    GLMNARD0
     C                   EVAL      PAdditional1 = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndErr - Send Error Message                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRSndErr      BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PZaPgm
     C                   PARM                    PZaPgrl
     C                   PARM                    PMsgID
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgDta
     C                   PARM                    PZaMstp
      *
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkFld - Check which all fields are in Error                *
      *                                                               *
      * Called by: SRValidate                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRChkFld      BEGSR
      *
     C                   EVAL      WPos = %LOOKUP('DDEX1':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN31 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX2':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN32 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX3':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN33 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX4':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN34 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX5':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN35 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX6':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN36 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX7':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN37 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX8':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN38 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX9':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN39 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX10':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN40 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX11':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN41 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX12':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN42 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX13':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN43 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX14':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN44 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX15':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN45 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX16':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN46 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX17':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN47 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX18':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN48 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX19':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN49 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX20':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN50 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX21':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN51 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   EVAL      WPos = %LOOKUP('DDEX22':FldNamXAr)
     C                   IF        WPos <> *ZEROS
     C                   EVAL      *IN52 = '1'
     C                   EVAL      PMsgID = MsgIdXAr(WPos)
     C                   EVAL      PMsgDta = MsgDtaXAr(WPos)
     C                   EXSR      SRSndErr
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                    BUG26088A
      /EJECT                                                                               BUG26088A
      *****************************************************************                    BUG26088A
      *                                                               *                    BUG26088A
      * SRValAddInfo - Validate Additional Information                *                    BUG26088A
      *                                                               *                    BUG26088A
      * Called by: Main Processing                                    *                    BUG26088A
      *                                                               *                    BUG26088A
      * Calls: None                                                   *                    BUG26088A
      *                                                               *                    BUG26088A
      *****************************************************************                    BUG26088A
      *                                                                                    BUG26088A
     C     SRValAddInfo  BEGSR                                                             BUG26088A
      *                                                                                    BUG26088A
     C                   IF        WEdtind = ' '                                           BUG26088A
      *                                                                                    BUG26088A
     C                   EVAL      WValAddInfoFlg = 'N'                                    BUG26088A
     C                   EVAL      KBTNB = DDBANB                                          BUG26088A
     C                   MOVE      DDITNB        KBINB                                     BUG26088A
     C     KGLJENX       CHAIN     GLJENXL2                                                BUG26088A
     C                   IF        %FOUND(GLJENXL2)                                        BUG26088A
     C                   EVAL      WDetails = BAADI1 +BAADI2 +BAADI3 +BAADI4+              BUG26088A
     C                                        BAADI5 +BAADI6                               BUG26088A
     C                   IF        WDetails <> *BLANKS                                     BUG26088A
     C                   EVAL      WValAddInfoFlg = 'Y'                                    BUG26088A
     C                   ENDIF                                                             BUG26088A
     C                   ENDIF                                                             BUG26088A
      *                                                                                    BUG26088A
     C                   ENDIF                                                             BUG26088A
      *                                                                                    BUG26088A
     C                   ENDSR                                                             BUG26088A
      *
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
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRetCodeIn
     C                   PARM                    PPostDetails
     C                   PARM                    PPostDate
     C                   PARM                    PAdditional1
     C                   PARM                    PMode
     C                   PARM                    PExit
     C                   PARM                    PCancel
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRtCd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move Workstation ID to screen field
      *
     C                   EVAL      DDRUNA = BJMRDT
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWSID = PSJobName
     C                   EVAL      DDPGMQ = PSProcMod
      *
      ** Initialise Work Fields
      *
     C                   EVAL      PDateFormat = BJDFIN
     C                   EVAL      WError = 'N'
     C                   EVAL      WValAddInfoFlg = 'N'                                    BUG26088A
      *
      ** KLIST for GLMNARL3
      *
     C     KJENX         KLIST
     C                   KFLD                    KAPODT
     C                   KFLD                    KABANB
     C                   KFLD                    KAITNB
      *                                                                                    BUG26088A
      ** KLIST for GLJENXL2                                                                BUG26088A
      *                                                                                    BUG26088A
     C     KGLJENX       KLIST                                                             BUG26088A
     C                   KFLD                    KBTNB                                     BUG26088A
     C                   KFLD                    KBINB                                     BUG26088A
      *
      ** KList for file GLNW94L11
      *
     C     KAcct         KLIST
     C                   KFLD                    KBrca
     C                   KFLD                    KCNum
     C                   KFLD                    KCcy
     C                   KFLD                    KAccd
     C                   KFLD                    KAcsq
      *
     C                   ENDSR
      *
      *********************************************************************
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
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
      *
     C                   CALLB     'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
