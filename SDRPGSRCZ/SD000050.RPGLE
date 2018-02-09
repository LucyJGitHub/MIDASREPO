     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD KYC Investigation Items')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data  Module                                *
      *                                                               *
      *  SD000050 - Midas SD KYC Investigation Items                  *
      *                                                               *
      *  Function:  This program is to inquire all the KYC Items and  *
      *             outstanding KYC items.                            *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 BUG10603           Date 14Feb06               *
      *                 CSD028  *CREATE    Date 22Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  BUG10603 - Change Control for KYC                            *
      *           - Program conversion to subfile processing.         *
      *  CSD028 - KYC (Standing Data Authorisations)                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 - Exit  Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD KYC Investigation items screen
     FSD000050DFCF   E             WORKSTN
     F                                     SFILE(SD000050S0:#0SFRN)                         BUG10603
 
      ** KYC Investigation Items
     FSDKYCIL0  IF   E           K DISK
     F                                     INFSR(*PSSR)                                     BUG10603
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D*RUNDAT***     E DS                  EXTNAME(RUNDAT)                                  BUG10603
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External Midas SD KYC item
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ***First*DS*for*access*programs,*short*data*structure************                     BUG10603
     D*SDCUST***     E DS                  EXTNAME(SDCUSTPD)                                BUG10603
      *****************************************************************                     BUG10603
     D**********       DS                                                                   BUG10603
     D*DKYALLI**               1    500                                                     BUG10603
     D*#1ALI1***               1     64                                                     BUG10603
     D*#1ALI2***              65    128                                                     BUG10603
     D*#1ALI3***             129    192                                                     BUG10603
     D*#1ALI4***             193    256                                                     BUG10603
     D*#1ALI5***             257    320                                                     BUG10603
     D*#1ALI6***             321    384                                                     BUG10603
     D*#1ALI7***             385    448                                                     BUG10603
     D*#1ALI8***             449    500                                                     BUG10603
     D**********       DS                                                                   BUG10603
     D*DKYOUTI**               1    500                                                     BUG10603
     D*#1OTI1***               1     64                                                     BUG10603
     D*#1OTI2***              65    128                                                     BUG10603
     D*#1OTI3***             129    192                                                     BUG10603
     D*#1OTI4***             193    256                                                     BUG10603
     D*#1OTI5***             257    320                                                     BUG10603
     D*#1OTI6***             321    384                                                     BUG10603
     D*#1OTI7***             385    448                                                     BUG10603
     D*#1OTI8***             449    500                                                     BUG10603
      *****************************************************************                     BUG10603
     D**********       DS                                                                   BUG10603
     D*V0CUSN***               1      6                                                     BUG10603
     D*X0CUSN***               1      6  0                                                  BUG10603
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Indicator Array Overlay Data Structure                                             BUG10603
     D INPTR           S               *   INZ(%ADDR(*IN))                                  BUG10603
     D                 DS                  BASED(INPTR)                                     BUG10603
                                                                                            BUG10603
      ** Function Key Indicators                                                            BUG10603
     D  F03                   03     03                                                     BUG10603
                                                                                            BUG10603
      ** Subfile Management Indicators                                                      BUG10603
     D  SFLCLR                91     91                                                     BUG10603
     D  SFLDSP                92     92                                                     BUG10603
     D  SFLEND                93     93                                                     BUG10603
                                                                                            BUG10603
     D                 DS                                                                   BUG10603
     D #0LINE                                                                               BUG10603
     D  #0HEAD                       76A   OVERLAY(#0LINE:1)                                BUG10603
     D  #0DETL                       74A   OVERLAY(#0LINE:3)                                BUG10603
                                                                                            BUG10603
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters                                                                   BUG10603
     D PCustNum        S              6A                                                    BUG10603
                                                                                            BUG10603
      ** Access Object Parameters                                                           BUG10603
     D PRtCd           S              7A                                                    BUG10603
     D POptn           S              7A                                                    BUG10603
                                                                                            BUG10603
      ** KYC Item Parser Parameters                                                         BUG10603
     D PItem           S           5000A                                                    BUG10603
     D PStaFlg         S              1A                                                    BUG10603
     D PLength         S              4P 0                                                  BUG10603
     D PToken          S             80A                                                    BUG10603
     D PTknTyp         S              7A                                                    BUG10603
     D PCurIdx         S              4P 0                                                  BUG10603
     D PStatus         S             10A                                                    BUG10603
                                                                                            BUG10603
      ** Key Fields                                                                         BUG10603
     D KCNUM           S                   LIKE(KYCNUM)                                     BUG10603
                                                                                            BUG10603
     D*@RUN*****       S              1                                                     BUG10603
      *****************************************************************                     BUG10603
     D*PRTCD****       S              7                                                     BUG10603
     D*POPTN****       S              7                                                     BUG10603
     D*PCNUM****       S             10                                                     BUG10603
     D*PCNST****       S              7                                                     BUG10603
     D*P0CUSN***       S              6                                                     BUG10603
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
     C                   EXSR      SRKYCIClr                                                BUG10603
                                                                                            BUG10603
     C                   MOVE      PCustNum      KCNUM                                      BUG10603
     C     KCNUM         CHAIN     SDKYCIL0                                                 BUG10603
                                                                                            BUG10603
     C                   IF        %FOUND                                                   BUG10603
                                                                                            BUG10603
      ** Process the ALL KYC Item.                                                          BUG10603
                                                                                            BUG10603
     C                   EXSR      SRKYCIBdA                                                BUG10603
                                                                                            BUG10603
      ** Process the OUTstanding KYC Item.                                                  BUG10603
                                                                                            BUG10603
     C                   EXSR      SRKYCIBdO                                                BUG10603
                                                                                            BUG10603
     C                   ELSE                                                               BUG10603
     C                   EXSR      SRNoData                                                 BUG10603
     C                   ENDIF                                                              BUG10603
                                                                                            BUG10603
     C                   DOW       F03 <> *ON                                               BUG10603
     C                   EXSR      SRKYCIDsp                                                BUG10603
     C                   ENDDO                                                              BUG10603
                                                                                            BUG10603
     C                   EVAL      *INLR = *ON                                              BUG10603
                                                                                            BUG10603
      ***Read*in*Installation*Data*************************************                     BUG10603
      *****************************************************************                     BUG10603
     C******DTAARA       DEFINE                  RUNDAT                                     BUG10603
     C******DTAARA       DEFINE                  LDA                                        BUG10603
     C**********         IN        RUNDAT                                                   BUG10603
      *****************************************************************                     BUG10603
      ***Set*Date*Format*Indicator**IN98**on*if*date*format*is*MMDDYY**                     BUG10603
      *****************************************************************                     BUG10603
     C**********         IF        AGDFF = 'M'                                              BUG10603
     C**********         EVAL      *IN98 = *ON                                              BUG10603
     C**********         ENDIF                                                              BUG10603
      *****************************************************************                     BUG10603
     C**********         EVAL      #1CUSN = P0CUSN                                          BUG10603
     C**********         MOVE      P0CUSN        X0CUSN                                     BUG10603
      *****************************************************************                     BUG10603
      ***Access*Customer*details***************************************                     BUG10603
      *****************************************************************                     BUG10603
     C*****X0CUSN        CHAIN     SDKYCIL0                                                 BUG10603
     C**********         IF        %FOUND(SDKYCIL0)                                         BUG10603
     C**********         EVAL      DKYOUTI = KYOUTI                                         BUG10603
     C**********         EVAL      DKYALLI = KYALLI                                         BUG10603
     C**********         ENDIF                                                              BUG10603
     C**********         DOW       *IN03 = *Off                                             BUG10603
     C**********         WRITE     SD0050F0                                                 BUG10603
     C**********         WRITE     SD0050F1                                                 BUG10603
     C**********         EXFMT     SD0050F2                                                 BUG10603
     C**********         ENDDO                                                              BUG10603
     C*****************************************************************                     BUG10603
     C**********         EVAL      *INLR   = *ON                                            BUG10603
     C**********         RETURN                                                             BUG10603
      *****************************************************************                     BUG10603
      /EJECT                                                                                BUG10603
      *****************************************************************                     BUG10603
      *                                                               *                     BUG10603
      *  SRKYCIBdA - Builds the KYC Item subfile (ALL).               *                     BUG10603
      *                                                               *                     BUG10603
      *****************************************************************                     BUG10603
     C     SRKYCIBdA     BEGSR                                                              BUG10603
                                                                                            BUG10603
     C                   EVAL      PItem = KYALLI                                           BUG10603
     C                   EVAL      PStaFlg = 'N'                                            BUG10603
                                                                                            BUG10603
      ** Print the type of item being processed.                                            BUG10603
                                                                                            BUG10603
     C                   EVAL      #0HEAD = 'ALL KYC ITEMS:'                                BUG10603
     C                   EVAL      #0SFRN = #0SFRN + 1                                      BUG10603
     C                   WRITE     SD000050S0                                               BUG10603
                                                                                            BUG10603
      ** Print a blank line.                                                                BUG10603
                                                                                            BUG10603
     C                   EVAL      #0LINE = *BLANKS                                         BUG10603
     C                   EVAL      #0SFRN = #0SFRN + 1                                      BUG10603
     C                   WRITE     SD000050S0                                               BUG10603
                                                                                            BUG10603
     C                   IF        PItem <> *BLANKS                                         BUG10603
                                                                                            BUG10603
     C                   EVAL      POptn = '*FIRST '                                        BUG10603
     C                   EXSR      SRKYCIRed                                                BUG10603
                                                                                            BUG10603
     C                   EVAL      POptn = '*NEXT  '                                        BUG10603
                                                                                            BUG10603
     C                   DOW       PRtCd <> '*EOL   '                                       BUG10603
                                                                                            BUG10603
     C                   EVAL      #0LINE = *BLANKS                                         BUG10603
                                                                                            BUG10603
     C                   SELECT                                                             BUG10603
                                                                                            BUG10603
      ** If token returned is a Collection, print as heading.                               BUG10603
                                                                                            BUG10603
     C                   WHEN      PTknTyp = '*COL   '                                      BUG10603
     C                   EVAL      #0HEAD = PToken                                          BUG10603
                                                                                            BUG10603
      ** If token returned is a Document, print as detail.                                  BUG10603
                                                                                            BUG10603
     C                   WHEN      PTknTyp = '*DOC   '                                      BUG10603
     C                   EVAL      #0DETL = PToken                                          BUG10603
                                                                                            BUG10603
     C                   ENDSL                                                              BUG10603
                                                                                            BUG10603
     C                   EVAL      #0SFRN = #0SFRN + 1                                      BUG10603
     C                   WRITE     SD000050S0                                               BUG10603
                                                                                            BUG10603
     C                   EXSR      SRKYCIRed                                                BUG10603
     C                   ENDDO                                                              BUG10603
                                                                                            BUG10603
     C                   ELSE                                                               BUG10603
     C                   EXSR      SRNoData                                                 BUG10603
     C                   ENDIF                                                              BUG10603
                                                                                            BUG10603
      ** Print another blank line to separate the next item.                                BUG10603
                                                                                            BUG10603
     C                   EVAL      #0LINE = *BLANKS                                         BUG10603
     C                   EVAL      #0SFRN = #0SFRN + 1                                      BUG10603
     C                   WRITE     SD000050S0                                               BUG10603
                                                                                            BUG10603
     C                   ENDSR                                                              BUG10603
      *****************************************************************                     BUG10603
      /EJECT                                                                                BUG10603
      *****************************************************************                     BUG10603
      *                                                               *                     BUG10603
      *  SRKYCIBdO - Builds the KYC Item subfile (OUTstanding).       *                     BUG10603
      *                                                               *                     BUG10603
      *****************************************************************                     BUG10603
     C     SRKYCIBdO     BEGSR                                                              BUG10603
                                                                                            BUG10603
     C                   EVAL      PItem = KYOUTI                                           BUG10603
     C                   EVAL      PStaFlg = 'Y'                                            BUG10603
                                                                                            BUG10603
      ** Print the type of item being processed.                                            BUG10603
                                                                                            BUG10603
     C                   EVAL      #0HEAD = 'OUTSTANDING KYC ITEMS:'                        BUG10603
     C                   EVAL      #0SFRN = #0SFRN + 1                                      BUG10603
     C                   WRITE     SD000050S0                                               BUG10603
                                                                                            BUG10603
      ** Print a blank line.                                                                BUG10603
                                                                                            BUG10603
     C                   EVAL      #0LINE = *BLANKS                                         BUG10603
     C                   EVAL      #0SFRN = #0SFRN + 1                                      BUG10603
     C                   WRITE     SD000050S0                                               BUG10603
                                                                                            BUG10603
     C                   IF        PItem <> *BLANKS                                         BUG10603
                                                                                            BUG10603
     C                   EVAL      POptn = '*FIRST '                                        BUG10603
     C                   EXSR      SRKYCIRed                                                BUG10603
                                                                                            BUG10603
     C                   EVAL      POptn = '*NEXT  '                                        BUG10603
                                                                                            BUG10603
     C                   DOW       PRtCd <> '*EOL   '                                       BUG10603
                                                                                            BUG10603
     C                   EVAL      #0LINE = *BLANKS                                         BUG10603
                                                                                            BUG10603
     C                   SELECT                                                             BUG10603
                                                                                            BUG10603
      ** If token returned is a Collection, print as heading.                               BUG10603
                                                                                            BUG10603
     C                   WHEN      PTknTyp = '*COL   '                                      BUG10603
     C                   EVAL      #0HEAD = PToken                                          BUG10603
                                                                                            BUG10603
      ** If token returned is a Document, print as detail.                                  BUG10603
                                                                                            BUG10603
     C                   WHEN      PTknTyp = '*DOC   '                                      BUG10603
     C                   EVAL      #0DETL = PToken                                          BUG10603
     C                   ENDSL                                                              BUG10603
                                                                                            BUG10603
     C                   EVAL      #0SFRN = #0SFRN + 1                                      BUG10603
     C                   WRITE     SD000050S0                                               BUG10603
                                                                                            BUG10603
     C                   EXSR      SRKYCIRed                                                BUG10603
     C                   ENDDO                                                              BUG10603
                                                                                            BUG10603
     C                   ELSE                                                               BUG10603
     C                   EXSR      SRNoData                                                 BUG10603
     C                   ENDIF                                                              BUG10603
                                                                                            BUG10603
     C                   ENDSR                                                              BUG10603
      *****************************************************************                     BUG10603
      /EJECT                                                                                BUG10603
      *****************************************************************                     BUG10603
      *                                                               *                     BUG10603
      *  SRKYCIClr - Clears the KYC Item subfile.                     *                     BUG10603
      *                                                               *                     BUG10603
      *****************************************************************                     BUG10603
     C     SRKYCIClr     BEGSR                                                              BUG10603
                                                                                            BUG10603
     C                   EVAL      SFLCLR = *ON                                             BUG10603
     C                   WRITE     SD000050C0                                               BUG10603
     C                   EVAL      SFLCLR = *OFF                                            BUG10603
                                                                                            BUG10603
     C                   ENDSR                                                              BUG10603
      *****************************************************************                     BUG10603
      /EJECT                                                                                BUG10603
      *****************************************************************                     BUG10603
      *                                                               *                     BUG10603
      *  SRKYCIDsp - Displays the KYC Item subfile.                   *                     BUG10603
      *                                                               *                     BUG10603
      *****************************************************************                     BUG10603
     C     SRKYCIDsp     BEGSR                                                              BUG10603
                                                                                            BUG10603
     C                   WRITE     SD000050F0                                               BUG10603
     C                   WRITE     SD000050F1                                               BUG10603
     C                   WRITE     SD000050C0                                               BUG10603
     C                   READ      SD000050C0                                               BUG10603
                                                                                            BUG10603
     C                   ENDSR                                                              BUG10603
      *****************************************************************                     BUG10603
      /EJECT                                                                                BUG10603
      *****************************************************************                     BUG10603
      *                                                               *                     BUG10603
      *  SRKYCIRed - Returns tokens from the input KYC Item.          *                     BUG10603
      *                                                               *                     BUG10603
      *****************************************************************                     BUG10603
     C     SRKYCIRed     BEGSR                                                              BUG10603
                                                                                            BUG10603
     C                   CALL      'SD000053'                                               BUG10603
     C                   PARM      *BLANKS       PRtCd                                      BUG10603
     C                   PARM                    POptn                                      BUG10603
     C                   PARM                    PItem                                      BUG10603
     C                   PARM                    PStaFlg                                    BUG10603
     C                   PARM                    PLength                                    BUG10603
     C                   PARM                    PToken                                     BUG10603
     C                   PARM                    PTknTyp                                    BUG10603
     C                   PARM                    PCurIdx                                    BUG10603
     C                   PARM                    PStatus                                    BUG10603
                                                                                            BUG10603
     C                   ENDSR                                                              BUG10603
      *****************************************************************                     BUG10603
      /EJECT                                                                                BUG10603
      *****************************************************************                     BUG10603
      *                                                               *                     BUG10603
      *  SRNoData - Prints 'No Data To Display'.                      *                     BUG10603
      *                                                               *                     BUG10603
      *****************************************************************                     BUG10603
     C     SRNoData      BEGSR                                                              BUG10603
                                                                                            BUG10603
     C                   EVAL      #0HEAD = '*** No Data To Display ***'                    BUG10603
     C                   EVAL      #0SFRN = #0SFRN + 1                                      BUG10603
     C                   EVAL      *IN21 = *ON                                              BUG10603
     C                   WRITE     SD000050S0                                               BUG10603
     C                   EVAL      *IN21 = *OFF                                             BUG10603
                                                                                            BUG10603
     C                   ENDSR                                                              BUG10603
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
     C**********         PARM                    P0CUSN                                     BUG10603
     C                   PARM                    PCustNum                                   BUG10603
                                                                                            BUG10603
     C     *DTAARA       DEFINE                  LDA                                        BUG10603
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA                                                      BUG10603
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA                                                      BUG10603
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C**********         EVAL      Suser = PSuser                                           BUG10603
     C**********         EVAL      SWSid = PSjobname                                        BUG10603
     C**********         EVAL      SRuna = BJMRDT                                           BUG10603
     C                   EVAL      #0RUNA = BJMRDT                                          BUG10603
     C                   EVAL      #0USER = PSUser                                          BUG10603
     C                   EVAL      #0WSID = PSJobName                                       BUG10603
     C                   EVAL      #0CNUM = PCustNum                                        BUG10603
                                                                                            BUG10603
     C                   EVAL      SFLDSP = *ON                                             BUG10603
     C                   EVAL      SFLEND = *ON                                             BUG10603
 
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C**********         IF        @RUN = *BLANK                                            BUG10603
     C**********         EVAL      @RUN = 'Y'                                               BUG10603
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C**********         ENDIF                                                              BUG10603
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
