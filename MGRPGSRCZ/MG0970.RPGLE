     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
     H FTRANS
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas MG MT970 Generation Batch')                      *
      **********************************************************************
      *                                                                    *
      *  Midas - ME Module                                                 *
      *                                                                    *
      *  MG0970 - MT970 Generation Batch                                   *
      *                                                                    *
      *  Function:  This module provides the batch job submitted by        *
      *             the user selection input in ME0902                     *
      *                                                                    *
      *  Component of: MGC0970 - MT970 Generation Batch                    *
      *                                                                    *
      *  (c) Misys International Banking Systems Ltd. 2005                 *
      *                                                                    *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 AR972805           Date 27Feb13               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7884            Date 15Jul05               *
      *                 BUG6480            Date 12Apr05                    *
      *                 CSW099  *CREATE    Date 28Feb05                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR972805 - Remove equate translation as done externally.     *
      *             Recompile over FTCPYSRC,FTSWIFTRAN.               *
      *             (Child: AR972806)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                       *
      *  BUG7884- CLS MT970 Msg Generation                                 *
      *  BUG6480 - Apply SC 232563 to this core version of program MGL063  *
      *  CSW099 - Creation of MT970 Netting Statements                     *
      *                                                                    *
      **********************************************************************
      *
     FMGF970L2  UF   E           K DISK    infsr(*PSSR)
      *
     FMEFNARL0  IF   E           K DISK    infsr(*PSSR)
     F                                     PREFIX(L_)
      *
     FRSACMTL1  IF   E           K DISK    infsr(*PSSR)
     F                                     IGNORE(APOSTPDF)
      *
     FDEALSALL  IF   E           K DISK    infsr(*PSSR)
     F                                     PREFIX(D_)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(MMDELDP0)
     F                                     IGNORE(MMDENBP0)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(FXDEALP0)
     F                                     IGNORE(DLBHISD0)
     F                                     IGNORE(DLCHISD0)
     F                                     IGNORE(DLDHISD0)
     F                                     IGNORE(DLEHISD0)
     F                                     IGNORE(DLGHISD0)
      *
     FACCNT     IF   E           K DISK    infsr(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      *
     FMGOMSGPD  O    E             DISK    infsr(*PSSR)
     F                                     COMMIT
      *
     FMGOREFPD  O    E             DISK    infsr(*PSSR)
     F                                     COMMIT
      *
     FMG0970AU  O    E             PRINTER USROPN
     FMG0970P1  O    E             PRINTER USROPN
      *
      ********************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              copyright
     D @WRK            S              1    DIM(50)                              concatenation field
     D @STR            S              1    DIM(50)                              String formatting
      *
      ** Array for formatting amount
     D AAMT            S              1    DIM(15)
      *
      ** Work array indicator
     D AIND            S              1    DIM(8)
      *
     D DSBOUT          DS
     D  BOUT                   1     35
     D  OUT1                   3     35
     D  OUT2                   6     35
      **  Data structure for bank to bank output
      *
     D                 DS
     D  CSID                   1     12
     D  @BIC                   9     11
      **  Data structure to test for BIC code
      *
     D MULT            DS                  OCCURS(95)
     D  MTAG                   1      5
     D  MFLD                   6     55
     D  MERR                  56    105
      **  Multiple occurrence data structure for message
      *
     D P@IN            DS           256
     D  I@SNBR                 1      3
     D  I@DSCN                 4      9
     D  I@MTPY                10     12
     D  I@SETT                13     14  0
     D  I@CONC                15     15
     D  I@FTCS                16     16
     D  I@MMOD                17     18
      ** Data structure for input parameter
      *
     D P@OUT           DS           256
     D**O@CNSN**               1      6  0                                                    CSD027
     D  O@CNSN                 1      6                                                       CSD027
     D  O@SWSN                 7     18
     D  O@NWSN                19     38
     D  O@SWDS                39     49
     D  W@96CN                46     46
     D  W@BIC                 47     49
     D  O@NWDS                50     69
     D  O@NWRK                70     75
     D  O@MGSG                76     76
     D  O@MGST                77     80
     D  O@PAIN                81     81
     D  O@PCNB                82     87
     D  O@SPRS                88     90
      ** Data structure for ouput parameter
      *
     D @20             DS
     D  @PFX                   1      2
     D  @DAT                   3      7  0
     D  @TIM                   8     13  0
     D  @SEQ                  14     16  0
      ** Transaction Reference Number data structure
      *
     D W0FULA          DS
     D  W0BRCD                 1      3
     D**W0CNUM**               4      9  0                                                    CSD027
     D  W0CNUM                 4      9                                                       CSD027
     D  W0CCY                 10     12
     D**W0ACOD***             13     16  0                                                   BUG7884
     D**W0ACSQ***             17     18  0                                                   BUG7884
     D  W0ACOD                13     22  0                                                   BUG7884
     D  W0ACSQ                23     24  0                                                   BUG7884
      ** Full Account Data Structure
      *
     D @DATA           DS
     D  @TAG4                  1      4
     D  @TAG5                  1      5
     D  @DAT4                  5    256
     D  @DAT5                  6    256
      ** Message data
      *
     D @28             DS
     D  @28S1                  1      5  0
     D  @28SL                  6      6
     D  @28S2                  7      8  0
      ** Field :28:
      *
     D @60X            DS
     D  @60XS1                 1      1
     D  @60XS2                 2      7
     D  @60XS3                 8     10
     D  @60XS4                11     25
      ** Field :60x:
      *
     D @61             DS
     D  @61S1                  1      6
     D  @61S2                  7     10
     D  @61S3                 11     11
     D  @61S5                 12     26
     D  @61S6                 27     30
     D  @61S6A                27     27
     D  @61S6B                28     30
     D  @61S7                 31     46
     D  @61S8                 47     55
     D  @61S8A                47     48
     D  @61S8B                49     49
     D  @61S8C                50     55
     D  @61S8D                49     55
      ** Field :61: subfields 1 to 8
      *
     D @62X            DS
     D  @62XS1                 1      1
     D  @62XS2                 2      7
     D  @62XS3                 8     10
     D  @62XS4                11     25
      ** Field :62:
      *
     D @64             DS
     D  @64S1                  1      1
     D  @64S2                  2      7
     D  @64S3                  8     10
     D  @64S4                 11     25
      ** Field :64:
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data structure for bank file
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  Data structure for customer file
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      **  Data structure for module ICD file
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      **  Data structure for nostro file
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      **  Data structure for message management data.
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Record formats for access to currency details
      *
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      ** Data structure for SWIFT BIC Directory file
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structure for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access programs
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Third data structure for access programs
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      **  Local data area
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  External data structures for Switchable Features Details
      *
     D Msg61Lin        C                   CONST(15)
      **  Max number of :61: tags in the message not to blow the Swift limit (2000 chars)
      *
      **********************************************************************
     C/EJECT
      *
      ** Initial process
      *
     C                   EXSR      INIT
      *
      ** Read the first record from the MT970 Accounts file
      *
     C     W0KEY1        KLIST
     C                   KFLD                    LBRCA
     C                   KFLD                    LCNUM
     C                   KFLD                    LCCY
     C                   KFLD                    LACOD
     C                   KFLD                    LACSQ
      *
     C                   MOVE      *LOVAL        LBRCA
     C                   MOVE      *LOVAL        LCNUM
     C                   MOVE      *LOVAL        LCCY
     C                   MOVE      *LOVAL        LACOD
     C                   MOVE      *LOVAL        LACSQ
      *
     C     W0KEY1        SETLL     MGF970L2                           1010
     C  N10              READ      MGF970L2                             1010
      *
      ** Format Message Control.
      *
      ** Do While records found on the MT970 Accounts file
      *
     C     *IN10         DOWEQ     *OFF
      *
     C                   ADD       1             LPROC
      *
      **  Set up sequence number and last run date for account
      *
     C     LLRDT         IFLE      BJPEYD
     C                   MOVE      BJRDNB        LLRDT
     C                   Z-ADD     1             LLMSQ
     C                   ENDIF
      *
     C     LLRDT         IFNE      BJRDNB
     C                   MOVE      BJRDNB        LLRDT
     C                   ADD       1             LLMSQ
     C                   ENDIF
      *
      **  Reset statement related variables
      *
     C                   MOVE      *BLANKS       W0TRNF           16
     C                   Z-ADD     0             W0LDLN            6 0
     C                   Z-ADD     0             @28S2
      *
      **  Set up key fields
      *
     C     W0KEY2        KLIST
     C                   KFLD                    LBRCA
     C                   KFLD                    LCNUM
     C                   KFLD                    LCCY
     C                   KFLD                    LACOD
     C                   KFLD                    LACSQ
     C                   KFLD                    WVDTE
      *
     C     W0KEY2        CHAIN     RSACMTL1                           1111
      *
      ** Do While records found on the GL Account Movements file
      *
     C     *IN11         DOWEQ     *OFF
      *
     C                   MOVE      TNMR          W0TNMR            6 0
     C     W0TNMR        CHAIN     DEALSDBF                           1212
      *
      * The deal must exist, be CLS-enabled and still active
      *
     C     *IN12         IFEQ      *OFF
     C     D_CLSS        ANDEQ     'Y'
     C     D_CHTP        ANDNE     'D'
     C     D_RECI        ANDNE     'M'
      *
      ** Header message must be set up only once for each MT970
      *
     C     W0LOP         IFEQ      0
      *
      ** Initialise non-constant fields
      *
     C                   EXSR      INTF
      *
      **  Set up W0FULA
      *
     C                   MOVE      LBRCA         W0BRCD
     C                   MOVE      LCNUM         W0CNUM
     C                   MOVE      LCCY          W0CCY
     C                   MOVE      LACOD         W0ACOD
     C                   MOVE      LACSQ         W0ACSQ
      *
      **  Clear multiple occurrence data structure
     C                   Z-ADD     1             X                 3 0
     C     X             OCCUR     MULT
     C     X             DOWLE     200
     C     MULT          ANDNE     *BLANKS
     C                   MOVE      *BLANKS       MULT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
      *
     C                   Z-ADD     0             X
      *
      **  Determine message routing
      *
     C                   EXSR      SRROUT
      *
      **  Format message fields.
      *
      ** Create field :20: (Transaction Reference Number)
     C                   EXSR      FLD20
      *
      ** Create field :25: (Account i/d)
     C                   EXSR      FLD25
      *
      ** Create field :28: (Statement number/sequence)
     C                   EXSR      FLD28
      *
      ** Create field :60: (Opening Balance)
     C                   EXSR      FLD60
      *
     C                   Z-ADD     1             W0LOP             1 0
      *
     C                   ENDIF
      *
     C     FUND          IFNE      *BLANKS
     C                   MOVE      'Y'           FTYN              1
     C                   ELSE
     C                   MOVE      'N'           FTYN
     C                   ENDIF
      *
     C                   MOVE      TRYP          L#TTYP
     C                   MOVE      FTYN          L#FTTR
      *
     C     K#FNAR        CHAIN     MEFNARL0                           2626
      *
      ** Create all field :61:s (Projected Postings)
     C                   EXSR      FLD61
      *
      ** Maintain Running Account Balance
     C     @61S3         IFEQ      'D'
     C                   ADD       MVAM          W@RABF
     C                   ELSE
     C                   SUB       MVAM          W@RABF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write end of mex for multi-part message, triggered in :61:
      *
     C     X             IFNE      0
     C     W0LOP         ANDEQ     0
      *
      ** Check for last item on the GL Account Movements
     C     W0LDLN        IFEQ      0
     C                   CALL      'MEC0905'
     C                   PARM                    LBRCA
     C                   PARM                    LCNUM
     C                   PARM                    LCCY
     C                   PARM                    LACOD
     C                   PARM                    LACSQ
     C                   PARM                    WVDTE
     C     W0LDLN        PARM      0             W0DLNO            6 0
     C                   ENDIF
      *
     C     W0TNMR        IFEQ      W0LDLN
     C                   MOVE      *ON           *IN11
     C                   ENDIF
      *
      ** Create field :62: (Closing Balance)
     C                   EXSR      FLD62
      *
      ** If end of mex, check field :64:
     C     @TAG5         IFEQ      ':62F:'
     C                   EXSR      FLD64
     C                   ENDIF
      *
     C                   EXSR      OMSG
      *
     C                   Z-ADD     0             X
      *
      ** End of message generation
      *
     C     @TAG5         IFEQ      ':64: '
      **  Update the MT970 Accounts file
      *                                                                                      BUG6480
     C                   Z-ADD     LLRDT         WLRDT                                       BUG6480
     C                   Z-ADD     LLMSQ         WLMSQ                                       BUG6480
     C     W0KEY1        CHAIN     MGF970L2                           1313                   BUG6480
     C                   Z-ADD     WLRDT         LLRDT                                       BUG6480
     C                   Z-ADD     WLMSQ         LLMSQ                                       BUG6480
     C                   UPDATE    MGF970D0
      **  COMIT all changes since no error on writing the message
     C                   COMMIT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next Account Movements record
      *
     C     W0KEY2        READE     RSACMTL1                             1111
      *
     C                   ENDDO
      *
      ** Write end of mex only if anything was done before
      *
     C     X             IFNE      0
      *
      ** Create field :62: (Closing Balance)
     C                   EXSR      FLD62
      *
      ** If end of mex, check tag :64:
     C                   EXSR      FLD64
      *
     C                   EXSR      OMSG
      *
     C                   Z-ADD     0             X
     C                   Z-ADD     0             W0LOP
      *
      **  Update the MT970 Accounts file
      *                                                                                      BUG6480
     C                   Z-ADD     LLRDT         WLRDT             5 0                       BUG6480
     C                   Z-ADD     LLMSQ         WLMSQ             5 0                       BUG6480
     C     W0KEY1        CHAIN     MGF970L2                           1313                   BUG6480
     C                   Z-ADD     WLRDT         LLRDT                                       BUG6480
     C                   Z-ADD     WLMSQ         LLMSQ                                       BUG6480
     C                   UPDATE    MGF970D0
      *
      **  COMIT all changes since no error on writing the message
     C                   COMMIT
      *
     C                   ENDIF
      *
      **  Read next customer transfer extract record
      *
     C                   READ      MGF970L2                             1010
     C                   ENDDO
      *
     C                   EXSR      REPT
      *
      **  Terminate program
     C                   SETON                                        LR
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD20                                          *
      * Function    :  Create field :20: (Transaction Reference       *
      *                Number)                                        *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD20         BEGSR
      *
     C                   Z-ADD     1             X
     C     X             OCCUR     MULT
     C                   MOVEA     *BLANKS       @WRK
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':20:'        @TAG5
     C                   MOVEL     MGMODI        @PFX
     C                   Z-ADD     BJRDNB        @DAT
      *
      ** Initialise Transaction Reference time subfield
     C                   TIME                    W#NEWT            6 0
     C     W#NEWT        IFEQ      W#OLDT
     C                   ADD       1             @SEQ
     C                   ELSE
     C                   Z-ADD     1             @SEQ
     C                   Z-ADD     W#NEWT        W#OLDT            6 0
     C                   Z-ADD     W#OLDT        @TIM
     C                   ENDIF
      *
     C                   MOVEL     @20           @DAT5
     C                   MOVEL     @DATA         MULT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD25                                          *
      * Function    :  Create field :25: (Account i/d)                *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD25         BEGSR
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEA     *BLANKS       @WRK
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':25:'        @TAG5
     C                   MOVEL     W0FULA        @DAT5
     C                   MOVEL     @DATA         MULT
      *
     C                   ENDSR
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD28                                          *
      * Function    :  Create field :28:(Statement number/Sequence)   *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     FLD28         BEGSR
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEA     *BLANKS       @WRK
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
      *
     C                   MOVEL     ':28C:'       @TAG5
      *
     C                   Z-ADD     LLMSQ         @28S1
     C                   ADD       1             @28S2
     C                   MOVEL     @28           @DAT5
      *
     C                   MOVEL     @DATA         MULT
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      *****************************************************************
      * Subroutine  :  FLD60                                          *
      * Function    :  Create field :60: (Opening balance)            *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0060     Return date in ISO format           *
      *                ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD60         BEGSR
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEA     *BLANKS       @WRK
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
      *
     C     W0TRNF        IFEQ      *BLANKS
      *
     C                   MOVEL     ':60F:'       @TAG5
     C                   MOVE      'D'           @60XS1
     C                   Z-ADD     0             @WKAMT           13 0
     C                   Z-ADD     @WKAMT        W@RABF           13 0
      *
     C                   ELSE
      *
     C                   MOVEL     ':60M:'       @TAG5
      *
     C                   MOVE      @62XS1        @60XS1
      *
     C*****@WKAMT        IFGT      0
     C*****              MOVE      'C'           @60XS1
     C*****              ELSE
     C*****              MOVE      'D'           @60XS1
     C*****              ENDIF
      *
     C                   ENDIF
      *
      ** Set up subfield 2 (date) and store for later use
     C                   MOVE      WVDTA         ZMDAY
     C                   CALL      'ZM0060'
     C                   PARM                    ZMDAY             5 0
     C     @60XS2        PARM                    ZMDATE            6
     C                   MOVE      ZMDATE        @RUND             6
      *
      ** Set up subfields 3 and 4 (Currency and Amount) nb. use
      ** currency code returned by ZM0040 in s/f 3 because this should
      ** be ISO standard value
     C                   CALL      'ZM0040'
     C                   PARM      @WKAMT        ZAMNT            13 0
     C                   PARM      W0CCY         ZCCY              3
     C     @60XS4        PARM                    ZSAMNT           15
     C     @60XS3        PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '002'         DBASE                      * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                      *  DBERR 002  *
     C                   MOVEL     'ZM0040  '    DBFILE                     * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move data to output record
     C                   MOVEL     @60X          @DAT5
      *
     C                   MOVEL     @DATA         MULT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD61                                          *
      * Function    :  Create all field :61:s (postings)              *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0060     Return date in ISO format           *
      *                ZM0040     Return ccy/amount in ISO format     *
      *                SF6        Create subfield 6                   *
      *                SF7        Create subfield 7                   *
      *                SF8        Create subfield 8                   *
      *                SF9        Create subfield 9                   *
      *****************************************************************
      *
     C     FLD61         BEGSR
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEA     *BLANKS       @WRK
      *
      ** Format all field :61:s
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   CLEAR                   @61
     C                   MOVEL     ':61:'        @TAG5
      *
      ** Set up subfield 1 (value date, YYMMDD)
     C                   CALL      'ZM0060'
     C                   PARM      VUDT          ZMDAY             5 0
     C     @61S1         PARM                    ZMDATE            6
      *
      ** Set up subfield 2 (posting date, MMDD)
     C*****PTDT          IFNE      0
     C*****              CALL      'ZM0060'
     C*****              PARM      PTDT          ZMDAY             5 0
     C*****W@61S2        PARM                    ZMDATE            6
     C*****              MOVE      W@61S2        @61S2
     C*****              ELSE
     C                   MOVE      *BLANKS       @61S2
     C*****              ENDIF
      *
      ** Set up subfield 3 (debit/credit indicator)
     C     DORC          IFEQ      0
     C                   MOVE      'D'           @61S3
     C                   ELSE
     C                   MOVE      'C'           @61S3
     C                   ENDIF
      *
      ** Set up subfield 5 (posting amount)
     C                   Z-ADD     MVAM          @WKAMT
     C                   CALL      'ZM0040'
     C                   PARM      @WKAMT        ZAMNT            13 0
     C                   PARM      W0CCY         ZCCY              3
     C     @61S5         PARM                    ZSAMNT           15
     C                   PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '003'         DBASE                      * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                      *  DBERR 003  *
     C                   MOVEL     'ZM0040  '    DBFILE                     * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Format subfield 6
     C                   EXSR      SF6
      *
      ** Format subfield 7
     C                   EXSR      SF7
      *
      ** Format subfield 8
     C                   EXSR      SF8
      *
     C     @61S8D        IFEQ      *BLANKS
     C                   CLEAR                   @61S8
     C                   ENDIF
      *
      ** When all subfields for this line formatted, compress and
      ** output to file.
     C     @DAT5         CAT       @61S1:0       @DAT5
     C     @DAT5         CAT       @61S2:0       @DAT5
     C     @DAT5         CAT       @61S3:0       @DAT5
     C     @DAT5         CAT       @61S5:0       @DAT5
     C     @DAT5         CAT       @61S6:0       @DAT5
     C     @DAT5         CAT       @61S7:0       @DAT5
     C     @DAT5         CAT       @61S8:0       @DAT5
      *
      ** Move data to output record
     C                   MOVEL     @DATA         MULT
      *
      ** Format subfield 9
     C                   EXSR      SF9
      *
     C                   if        X > (msg61lin + 3)
     C                   Z-ADD     0             W0LOP
      *
     C                   if        W0TRNF = *blanks
     C                   movel     @20           W0TRNF
     C                   endif
      *
     C                   endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF6                                            *
      * Function    :  Create subfield 6 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF6           BEGSR
      *
      ** First character of subfield 6 should always be 'F'
     C                   MOVE      'F'           @61S6A
      *
     C     *IN26         IFEQ      '0'
     C     L_LSTTI       ANDNE     *BLANKS
     C                   MOVE      L_LSTTI       @61S6B
     C                   ELSE
      *
      ** If unable to set up code, default to 'MSC' - miscellaneous
     C                   MOVE      'MSC'         @61S6B
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF7                                            *
      * Function    :  Create subfield 7 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF7           BEGSR
      *
      ** Use first 16 characters of narrative description
     C                   MOVEL     NRTD          @61S7
      *
     C                   ENDSR
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF8                                            *
      * Function    :  Create subfield 8 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF8           BEGSR
      *
      ** Subfield 8 should always begin with '//'
     C                   MOVE      '//'          @61S8A
      *
      ** Narrative details found
     C     TNMR          IFNE      *BLANKS
     C     *IN26         IFEQ      '0'
     C                   MOVE      L_LTRMD       @61S8B
     C                   MOVE      TNMR          @61S8C
     C                   ELSE
     C                   MOVE      TNMR          @61S8D
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  SF9                                            *
      * Function    :  Create subfield 9 for field :61:               *
      *                                                               *
      * Called by   :  FLD61                                          *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SF9           BEGSR
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEA     *BLANKS       @WRK
      *
      ** Clear tag & data fields for writing of subfield 9
     C                   CLEAR                   @DATA
      *
      ** Retrieve Swift Narrative from narrative table (If found)
     C     *IN26         IFEQ      '0'
     C                   MOVEL     L_LNATV       @DATA
     C                   END
      *
      ** If data in subfield 9, write to file
     C     @DATA         IFNE      *BLANKS
     C                   MOVEL     @DATA         MFLD
     C                   ELSE                                                                BUG7884
     C                   SUB       1             X                                           BUG7884
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD62                                          *
      * Function    :  Create field :62: (closing balance)            *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD62         BEGSR
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEA     *BLANKS       @WRK
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
      *
     C     W0TRNF        IFEQ      *BLANKS
     C     *in11         OREQ      *ON
     C                   MOVEL     ':62F:'       @TAG5
     C                   ELSE
     C                   MOVEL     ':62M:'       @TAG5
     C                   ENDIF
      *
      ** Set up subfield 1 (Debit/Credit indicator) nb. zero = credit
     C     W@RABF        IFLE      0
     C                   MOVE      'C'           @62XS1
     C                   Z-SUB     W@RABF        @WKAMT
     C                   ELSE
     C                   MOVE      'D'           @62XS1
     C                   Z-ADD     W@RABF        @WKAMT
     C                   ENDIF
      *
      ** Set up subfield 2 (date)
     C                   MOVE      @RUND         @62XS2
      *
      ** Set up subfields 3 and 4 (Currency and Amount) nb. use
      ** currency code returned by ZM0040 in s/f 3 because this should
      ** be ISO standard value
     C                   CALL      'ZM0040'
     C                   PARM      @WKAMT        ZAMNT            13 0
     C                   PARM      W0CCY         ZCCY              3
     C     @62XS4        PARM                    ZSAMNT           15
     C     @62XS3        PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '004'         DBASE                      * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                      *  DBERR 004  *
     C                   MOVEL     'ZM0040  '    DBFILE                     * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move data to output record
     C                   MOVEL     @62X          @DAT5
     C                   MOVEL     @DATA         MULT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      * Subroutine  :  FLD64                                          *
      * Function    :  Create field :64: (closing available balance)  *
      *                                                               *
      * Called by   :  CREATE                                         *
      * Calls       :  ZM0040     Return ccy/amount in ISO format     *
      *****************************************************************
      *
     C     FLD64         BEGSR
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   MOVEA     *BLANKS       @WRK
      *
      ** Set up field tag and data
     C                   CLEAR                   @DATA
     C                   MOVEL     ':64:'        @TAG5
      *
      ** Set up subfield 1 (Debit/Credit indicator) nb. zero = credit
     C     W@RABF        IFLE      0
     C                   MOVE      'C'           @64S1
     C                   Z-SUB     W@RABF        @WKAMT
     C                   ELSE
     C                   MOVE      'D'           @64S1
     C                   Z-ADD     W@RABF        @WKAMT
     C                   ENDIF
      *
      ** Set up subfield 2 (date)
     C                   MOVE      BJRDNB        ZMDAY
     C                   CALL      'ZM0060'
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZMDATE            6
     C                   MOVE      ZMDATE        @64S2
      *
     C     W0KEY3        KLIST
     C                   KFLD                    LCNUM
     C                   KFLD                    LCCY
     C                   KFLD                    LACOD
     C                   KFLD                    LACSQ
     C                   KFLD                    LBRCA
      *
     C     W0KEY3        CHAIN     ACCNT                              9999
      ** If program fails, report database error
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVE      '015'         DBASE                      * * * * * * * *
     C                   MOVEL     '*KEY   '     DBKEY                      *  DBERR 015  *
     C                   MOVEL     'ACCNT   '    DBFILE                     * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set up subfields 3 and 4 (Currency and Amount) nb. use
      ** currency code returned by ZM0040 in s/f 3 because this should
      ** be ISO standard value
     C                   CALL      'ZM0040'
     C                   PARM      CLBL          ZAMNT            13 0
     C                   PARM      W0CCY         ZCCY              3
     C     @64S4         PARM                    ZSAMNT           15
     C     @64S3         PARM                    ZSCCY             3
     C                   PARM      *BLANKS       ZERR              1
      *
      ** If program fails, report database error
     C     ZERR          IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '005'         DBASE                      * * * * * * * *
     C                   MOVEL     'PROGRAM'     DBKEY                      *  DBERR 005  *
     C                   MOVEL     'ZM0040  '    DBFILE                     * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move data to output record
     C                   MOVEL     @64           @DAT5
     C                   MOVEL     @DATA         MULT
      *
     C                   ADD       1             LREPO
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *
      *****************************************************************
      *   SRROUT - determine message routing                          *
      *   Called by - main process                                    *
      *   Calls -                                                     *
      *****************************************************************
      *
     C     SRROUT        BEGSR
      *
     C                   MOVE      W0BRCD        I@SNBR
     C                   MOVE      W0CNUM        I@DSCN
      *
     C                   MOVE      '970'         I@MTPY
      *
     C                   MOVE      'N'           I@CONC
     C                   Z-ADD     0             I@SETT
     C                   MOVE      *BLANK        I@FTCS
     C                   MOVE      MGMODI        I@MMOD
      *###################################################################
      *                                                                  #
      * Below are two copy sources intended for setting up the custom    #
      * parameter (P@ZZ) in the call to MG9900.                          #
      * One (MG9900CALL) is in ALL MG generation programs and is for use #
      * when a change is required to all of them.                        #
      * The other is only in this program.                               #
     C/COPY WNCPYSRC,MG9900CALL                                          #
     C/COPY WNCPYSRC,MG0970ROUT                                          #
      *                                                                  #
      *###################################################################
     C                   CALL      'MG9900'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    P@IN
     C                   PARM      *BLANKS       P@OUT
     C                   PARM                    P@ZZ            256
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '092'         DBASE                            * * * * * * *
     C                   MOVEL     '*CALL  '     DBKEY                            * DBERR 092 *
     C                   MOVEL     'MG9900'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      O@NWRK        NWRK
     C**********         Z-ADD     O@CNSN        SECN                                         CSD027
     C                   EVAL      SECN = O@CNSN                                              CSD027
     C                   MOVE      *BLANKS       @SND              6
     C                   MOVE      O@CNSN        @SND
     C                   MOVE      O@NWSN        NWSN
     C**********         Z-ADD     CUSN          DECN                                         CSD027
     C                   EVAL      DECN = CUSN                                                CSD027
     C                   MOVE      *BLANKS       @DST              6
     C                   MOVE      CUSN          @DST
     C                   MOVE      O@NWDS        NWDS
     C                   MOVE      O@MGSG        MGSG
     C                   MOVE      O@MGST        MGST
     C                   MOVE      O@PCNB        SPCNB
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *
      *****************************************************************
      *   REPT - print audit summary of processing                    *
      *   Called by - main process                                    *
      *   Calls     -                                                 *
      *****************************************************************
      *
     C     REPT          BEGSR
      *
     C                   OPEN      MG0970P1
      *
     C                   WRITE     HEADER
     C                   WRITE     TEXT
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *
      *****************************************************************
      *   OMSG - output correctly generated messages                  *
      *   Called by - main process                                    *
      *   Calls     - WREF - Write reference record to PF/MGOREFPD    *
      *****************************************************************
      *
     C     OMSG          BEGSR
      *
      ** Write reference record to PF/MGOREFPD.
      *
     C                   EXSR      WREF
      *
      **  Write multiple occurrence data structure to MGOMSGPD
      *
     C                   Z-ADD     1             X                 3 0
     C     X             OCCUR     MULT
     C     X             DOWLE     200                                                     1
     C     MFLD          ANDNE     *BLANKS
     C                   WRITE     MGOMSGD0                             06
      *
      **  Error on write to PF/MGOMSGPD (message data file)
      *
     C     *IN06         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '007'         DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 007 *
     C                   MOVEL     'MGOMSGPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END                                                              E1
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *
      *****************************************************************
      *   WREF - Write reference record to PF/MGOREFPD                *
      *   Called by - OMSG  output message PF/MGOMSGPD                *
      *   Calls     -                                                 *
      *****************************************************************
      *
     C     WREF          BEGSR
      *
     C                   MOVE      *BLANKS       SYTM
     C                   MOVEL     @20           TRNO
     C                   MOVEL     *BLANKS       TRNM
     C                   MOVEL     *BLANKS       TRNF
     C                   MOVE      *BLANKS       EVTP
     C                   Z-ADD     BJRDNB        AVDT
     C                   Z-ADD     0             ASEQ
     C                   MOVE      '970'         MTPY
     C                   MOVEL     *BLANKS       PTST
     C                   MOVEL     *BLANKS       CARQ
     C                   MOVEL     *BLANKS       MPDE
      *
      ** Use value date to calculate retention.
      *
     C     BJRDNB        ADD       ENDSMN        ZMDAY
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY
     C                   PARM                    ZSDATE
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '006'         DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 006 *
     C                   MOVEL     'ZM0060'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   MOVE      ZSDATE        @HRDT             6
     C                   MOVEL     @HRDT         HRDT
     C                   TIME                    MGTM
     C                   MOVE      BJMRDT        LADT
     C                   MOVE      MGTM          LATM
      *
     C     MGST          IFEQ      'CRTD'
     C                   MOVE      '1'           MGSG
     C                   END
     C     MGST          IFEQ      'RSND'
     C                   MOVE      BJMRDT        RELD
     C                   MOVE      MGTM          RELT
     C                   MOVE      '2'           MGSG
     C                   END
     C     MGST          IFEQ      'PRTD'
     C                   MOVE      '3'           MGSG
     C                   END
      *
     C                   MOVEL     *BLANKS       RUSR
     C                   MOVEL     *BLANKS       RWSN
     C                   MOVEL     *BLANKS       AMTS
     C                   MOVEL     *BLANKS       AMTX
      *
     C                   CALL      'ZM0060'                             15
     C                   PARM      WVDTE         ZMDAY             5 0
     C                   PARM                    ZMDATE            6
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '014'         DBASE                          * * * * * * * *
     C                   MOVEL     '       '     DBKEY                          *  DBERR 014  *
     C                   MOVEL     'ZM0060'      DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     ZMDATE        SVDT
      *
      ** Setup century indicator CINDV for value date SVDT
     C     SVDT          IFEQ      *BLANK
     C                   MOVE      *BLANK        CINDV
     C                   ELSE
     C                   MOVEL     SVDT          YY                2 0
     C     YY            IFLT      72
     C                   MOVE      '2'           CINDV
     C                   ELSE
     C                   MOVE      '1'           CINDV
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       SACN
     C                   MOVEL     *BLANKS       AORR
     C                   MOVEL     *BLANKS       DESI
      *
      **  Branch details
      *
     C                   MOVE      W0BRCD        BRCA
     C                   MOVE      *BLANKS       OTHB
     C                   MOVE      *BLANKS       OTHT
      *
     C                   MOVE      *BLANKS       NETI
     C                   MOVE      *BLANKS       DYST
     C                   MOVE      *BLANKS       RSID
     C                   MOVE      *BLANKS       MSE1
     C                   MOVE      *BLANKS       ELIN
     C                   MOVE      *BLANKS       SSAC
     C                   MOVE      *BLANKS       MIR
     C                   MOVE      'Y'           TSKS
     C                   MOVE      *BLANKS       TSKY
      *
     C                   WRITE     MGOREFD0                             05
      *
      **  Error on write to PF/MGOREFPD (message reference file)
      *
     C     *IN05         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '013'         DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 013 *
     C                   MOVEL     'MGOREFPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *
      *****************************************************************
      *   INTF  - Initialise non-constant fields.                     *
      *   Called by - main process.                                   *
      *   Calls     -                                                 *
      *****************************************************************
      *
     C     INTF          BEGSR
      *
     C                   MOVE      *BLANKS       TRNO
     C                   MOVE      MGMODI        MODI
     C                   MOVE      *BLANKS       SBTP
     C                   MOVE      *BLANKS       NWRK
     C**********         Z-ADD     0             SECN                                         CSD027
     C                   EVAL      SECN = *BLANKS                                             CSD027
     C                   MOVE      *BLANKS       NWSN
     C**********         Z-ADD     0             DECN                                         CSD027
     C                   EVAL      DECN = *BLANKS                                             CSD027
     C                   MOVE      *BLANKS       NWDS
     C                   Z-ADD     0             MGTM
     C                   Z-ADD     0             LATM
     C                   MOVE      *BLANKS       RELD
     C                   Z-ADD     0             RELT
     C                   MOVE      *BLANKS       AMTS
     C                   MOVE      *BLANKS       CINDV
     C                   MOVE      LCCY          CCY
     C                   Z-ADD     0             AVDT
      *
     C                   MOVE      *BLANKS       SCRNM            20
     C                   MOVE      *BLANKS       SCSID            12
     C                   MOVE      *BLANKS       STELX            10
     C                   MOVE      *BLANKS       SSTTX            12
     C                   MOVE      *BLANKS       SPCNB             6
     C                   MOVE      *BLANKS       DPCNB             6
     C                   MOVE      *BLANKS       @ERR              1
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *
      *****************************************************************
      *   DFLT - GET DEFAULT VALUES FROM SDCURRPD                     *
      *   Called by - main process                                    *
      *   Calls     -                                                 *
      *****************************************************************
     C     DFLT          BEGSR
      *
      *
      ** Call Access Program for Currency Details
      *       to Obtain DEFAULTS
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      LCCY          @BKCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     A6DPRU        IFEQ      'Y'
     C                   MOVE      'U'           MPRY
     C                   ELSE
     C                   MOVE      'N'           MPRY
     C                   END
      *
     C                   MOVE      A6NDWR        JEZ               2
     C                   MOVEL     A6DNOR        JEZ
      *
     C     JEZ           IFEQ      'NN'
     C                   MOVE      *BLANKS       DELC
     C                   END
     C     JEZ           IFEQ      'NY'
     C                   MOVE      '1'           DELC
     C                   END
     C     JEZ           IFEQ      'YN'
     C                   MOVE      '2'           DELC
     C                   END
     C     JEZ           IFEQ      'YY'
     C                   MOVE      '3'           DELC
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *
      *****************************************************************
      *   INIT - inital process                                       *
      *   Called by - main process                                    *
      *   Calls     -                                                 *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
     C     *entry        plist
     C                   parm                    WVDTA             5
      *
     C                   MOVE      WVDTA         WVDTE             5 0
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      ** Initialise work field for value date
      *
     C                   MOVE      *BLANKS       W@61S2            6
      *
      ** Initialise report work fields
      *
     C                   Z-ADD     0             LPROC
     C                   Z-ADD     0             LREPO
      *
      **  Set up LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'MG0970'      DBPGM
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA
      *
      ** Set up key list to access narrative table
     C     K#FNAR        KLIST
     C                   KFLD                    L#TTYP            2
     C                   KFLD                    L#FTTR            1
      *
      **  Access SDBANKPD for report title
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If no record is found on sdbankpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE                            * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                            * DBERR 001 *
     C                   MOVEL     'SDBANKPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Initialise date field for tags
      *
     C                   CALL      'ZM0060'
     C                   PARM      BJRDNB        ZMDAY             5 0
     C     W@MDAT        PARM                    ZMDATE            6
     C                   MOVE      ZMDATE        W@MDAT            6
      *
      **  Access SDMMODPD for modules available
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** If no record is found on sdmmodpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '002'         DBASE                            * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                            * DBERR 002 *
     C                   MOVEL     'SDMMODPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Access SDMGMEPD for message management data.
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMGME        PARM      SDMGME        DSFDY
      *
      ** If no record is found on sdmgmepd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '003'         DBASE                          * * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                          *  DBERR 003  *
     C                   MOVEL     'SDMGMEPD'    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Initialise constant fields
     C                   MOVE      *LOVAL        CR                1
     C                   BITON     '457'         CR
     C                   MOVE      *LOVAL        LF                1
     C                   BITON     '257'         LF
     C                   MOVEL     CR            CRLF              2
     C                   MOVE      LF            CRLF
      *
      **  CRLF Control Character for message data records
      *
     C                   MOVE      CRLF          CTRC
      *
      **  Convert run date to YYMMDD, for Message Generation Date
     C                   CALL      'ZM0060'                             15
     C                   PARM      BJRDNB        ZMDAY             5 0
     C                   PARM                    ZSDATE            6
      *
      ** Program ended in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '004'         DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 004 *
     C                   MOVEL     'ZM0060'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   MOVE      ZSDATE        MGDE
      *
      ** Set-up Message Generation  Century flag
      *
     C                   MOVEL     MGDE          YY                2 0
     C     YY            IFLT      72
     C                   MOVE      '2'           CIND
     C                   ELSE
     C                   MOVE      '1'           CIND
     C                   ENDIF
      *
     C                   MOVE      '970'         MTPY
     C                   MOVE      'N'           MPRY
     C                   MOVE      '1'           MGSG
     C                   MOVE      'CRTD'        MGST
      *
     C                   MOVEA     *BLANK        AIND
      *
     C                   MOVE      'GL'          MGMODI            2
     C                   MOVE      '/'           @28SL
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   *PSSR - error handling                                      *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      **  Write database error to report
      *
     C                   OPEN      MG0970AU
     C                   WRITE     HEAD
     C                   WRITE     DBERROR
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
     O/COPY FTCPYSRC,FTSWIFTRAN
** CPY@     : Copyright notice for inclusion in all programs
(c) Misys International Banking Systems Ltd. 2005
