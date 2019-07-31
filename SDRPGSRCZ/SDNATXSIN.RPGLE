     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-a/c Holder by Ctry of Tax - Maint')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNATXSIN - SD Customer Details by Country of Tax Input      *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Customer Details by Country of Tax.           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR742751           Date 07Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22582           Date 18May09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 233295             Date 29Apr05               *
      *                 233004             Date 13Apr05               *
      *                 232543             Date 15Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR742751 - Database Control Error encountered in Non Acct    *
      *             Holder Mnt (Child : AR742756) (Recompile)         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22582 - F3 and F12 perform the same action                *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  236137 - Change Control for CGL031 (Recompile)               *
      *  233295 - Deletion problems on Non-account Holders.           *
      *  233004 - Addtl Cust and Non-a/c Holder by Country of Tax     *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Customer Details by Country of Tax - Retrieve
     F***SDNHTXL1**IF*A*E           K Disk                                                    232543
     FSDNHTXL1  IF   E           K Disk                                                       232543
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** Current Details in File Format
      ** Use File format of SDNHTXPD as this is the actual current data
     D CrFilFmt      E DS                  Extname(SDNHTXPD)
     D
 
      ** New Details in File Format
     D NwFilFmt      E DS                  Extname(SDVNATXPD)
     D                                     Prefix(NF)
 
      ** Current Details in Screen Format
     D CrSflFmt      E DS                  Extname(SDNATXPD)
 
      ** New Details in Screen Format
     D NwSflFmt      E DS                  Extname(SDNATXPD)
     D                                     Prefix(NS)
 
      ** Error Indicators
     D OkFlags       E DS                  Extname(SDENATXPD)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** SAR Details Data Structure
     D SCSARD        E DS                  Extname(SCSARDPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  Extname(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameter
     D PActn           S              1A
     D PNAHO           S             10A
     D PFKey           S              2A                                                    BUG22582
 
      ** Work Variables
     D PRtcd           S              7A
     D POptn           S              7A
     D PBDSFL          S              1A
     D PRDSFL          S              1A
     D PUPSFL          S              1A
     D PRepair         S              1A
     D PProtect        S              1A
     D PActCde         S              1A                                                      233295
 
      ** Read Next Subfile record flag
     D WRdNxBr         S              1A
 
      ***Update*flag***************************************************                       232543
     D***WUpdFlag        S              1A                                                    232543
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D PRespMode       S              1A   Inz('S')
 
      ** Mode of operation
     D***PModeOfOp       S              6A                                                    232543
     D PModeOfOp       S              6A   INZ('*SIN  ')                                      232543
 
      ** Keep track of last country of tax displayed
     D PLastCTTX       S              2A
 
      ** Error message reference
     D PErrMsg         S              7A
 
      ** Function Keys
     D PINKE           S              1A
     D PINKC           S              1A
     D PINKL           S              1A
 
      ** Screen / function
     D WScrn           S              1A
 
      ** Query check in key screen customer number field
     D KEYQUERY        S              1A
 
      ** Index of errors
     D Idx             S              3P 0
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      INITIAL
 
     C                   DOW       WScrn <> 'T'
 
     C                   SELECT
 
      ** Build browse subfile record
 
     C                   WHEN      WScrn = 'B'
     C                   EXSR      SRBldBrw
 
      ** Continue browsing without rebuilding
 
     C                   WHEN      WScrn = 'C'
     C                   EXSR      SRContBrw
 
      ** Read subfile record
 
     C                   WHEN      WScrn = 'R'
     C                   EXSR      SRRdSflr
 
      ** Update subfile record (reverse image)
 
     C                   WHEN      WScrn = 'A'
     C                   EXSR      SRRIBrw
 
      ** Update Master File
 
     C                   WHEN      WScrn = 'U'
     C                   EXSR      SRUpdFile
 
     C                   ENDSL
 
     C                   ENDDO
      *                                                                                     BUG22582
      ** Populate return key parm                                                           BUG22582
     C                   IF        PINKC = '1'                                              BUG22582
     C                   EVAL      PFKey = 'KC'                                             BUG22582
     C                   ELSEIF    PINKL = '1'                                              BUG22582
     C                   EVAL      PFKey = 'KL'                                             BUG22582
     C                   ENDIF                                                              BUG22582
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBldBrw - Build Browse Subfile                               *
      *****************************************************************
     C     SRBldBrw      BEGSR
 
     C                   CALLB     'SDNATXBRW'
 
      * Input Parameters :
 
      ** Return Code
      ** Non-a/c Holder
      ** Build subfile
      ** Read subfile record
      ** Update subfile record display
      ** Repair Mode Indicator
      ** Protect Fields
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    DDNAHO
     C                   PARM      'Y'           PBDSFL
     C                   PARM      *Blanks       PRDSFL
     C                   PARM      *Blanks       PUPSFL
     C                   PARM      *Blanks       PRepair
     C                   PARM                    PProtect
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Output Parameters :
 
      ** Current Details in Screen Format
      ** Error Flags
      ** Read Next Record Flag
      ** Last CTTX displayed
      ** Command Keys
     C                   PARM                    NwSflFmt
     C                   PARM                    OkFlags
     C                   PARM      'N'           WRdNxBr
     C                   PARM                    PLastCTTX
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKL
 
     C                   IF        RetCodeIn = '*EMPTY'
     C                   RETURN
     C                   ENDIF
 
     C                   SELECT
 
      ** If F3 taken, End Program
 
     C                   WHEN      PINKC = '1'
     C                             Or PINKL = '1'
     C                   EVAL      WScrn = 'T'
 
      ** If Refresh, rebuild subfile
 
     C                   WHEN      PINKE = '1'
     C                   EVAL      WScrn = 'B'
 
      ***If*enquiry,*continue*browsing*upon*pressing*enter*************                       233004
                                                                                              233004
     C**********         WHEN      PActn = 'E'                                                233004
     C**********         EVAL      WScrn = 'C'                                                233004
 
      ** If Enter was pressed, start reading subfile records
      ** for validation
 
     C                   OTHER
     C                   EVAL      WScrn = 'R'
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRContBrw - Continue Browsing Subfile                         *
      *****************************************************************
     C     SRContBrw     BEGSR
 
     C                   CALLB     'SDNATXBRW'
 
      * Input Parameters :
 
      ** Return Code
      ** Non-a/c Holder
      ** Build subfile
      ** Read subfile record
      ** Update subfile record display
      ** Repair Mode Indicator
      ** Protect Fields
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    DDNAHO
     C                   PARM      *Blanks       PBDSFL
     C                   PARM      *Blanks       PRDSFL
     C                   PARM      *Blanks       PUPSFL
     C                   PARM      *Blanks       PRepair
     C                   PARM                    PProtect
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Output Parameters :
 
      ** Current Details in Screen Format
      ** Error Flags
      ** Read Next Record Flag
      ** Last CTTX displayed
      ** Command Keys
     C                   PARM                    NwSflFmt
     C                   PARM                    OkFlags
     C                   PARM      'N'           WRdNxBr
     C                   PARM                    PLastCTTX
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKL
 
     C                   IF        RetCodeIn = '*EMPTY'
     C                   RETURN
     C                   ENDIF
 
     C                   SELECT
 
      ** If F3 taken, End Program
 
     C                   WHEN      PINKC = '1'
     C                             Or PINKL = '1'
     C                   EVAL      WScrn = 'T'
 
      ** If Refresh, rebuild subfile
 
     C                   WHEN      PINKE = '1'
     C                   EVAL      WScrn = 'B'
 
      ** If Enter was pressed, start reading subfile records
      ** for validation
 
     C                   OTHER
     C                   EVAL      WScrn = 'R'
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRIBrw - Display current subfile record in reverse image     *
      *****************************************************************
     C     SRRIBrw       BEGSR
 
     C                   CALLB     'SDNATXBRW'
 
      * Input Parameters :
 
      ** Return Code
      ** Non-a/c Holder
      ** Build subfile
      ** Read subfile record
      ** Update subfile record display
      ** Repair Mode Indicator
      ** Protect Fields
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    DDNAHO
     C                   PARM      *Blanks       PBDSFL
     C                   PARM      *Blanks       PRDSFL
     C                   PARM      'Y'           PUPSFL
     C                   PARM      *Blanks       PRepair
     C                   PARM                    PProtect
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Output Parameters :
 
      ** Current Details in Screen Format
      ** Error Flags
      ** Read Next Record Flag
      ** Last CTTX displayed
      ** Command Keys
     C                   PARM                    NwSflFmt
     C                   PARM                    OkFlags
     C                   PARM      'N'           WRdNxBr
     C                   PARM                    PLastCTTX
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKL
 
      ** Continue reading subfile records
 
     C**********         IF        WUpdFlag <> 'Y'                                            232543
     C                   EVAL      WScrn = 'R'
     C**********         ELSE                                                                 232543
     C**********         EVAL      WScrn = 'T'                                                232543
     C**********         ENDIF                                                                232543
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdBrw - Read Next Browse Subfile Record                     *
      *****************************************************************
     C     SRRdSflr      BEGSR
 
     C                   CALLB     'SDNATXBRW'
 
      * Input Parameters :
 
      ** Return Code
      ** Non-a/c Holder
      ** Build subfile
      ** Read subfile record
      ** Update subfile record display
      ** Repair Mode Indicator
      ** Protect Fields
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    DDNAHO
     C                   PARM      *Blanks       PBDSFL
     C                   PARM      'Y'           PRDSFL
     C                   PARM      *Blanks       PUPSFL
     C                   PARM      *Blanks       PRepair
     C                   PARM                    PProtect
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Output Parameters :
 
      ** Current Details in Screen Format
      ** Error Flags
      ** Read Next Record Flag
      ** Last CTTX displayed
      ** Command Keys
     C                   PARM                    NwSflFmt
     C                   PARM                    OkFlags
     C                   PARM                    WRdNxBr
     C                   PARM                    PLastCTTX
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKL
 
     C                   IF        WRdNxBr = 'Y'
     C                   EXSR      SRRtvFlDtl
     C                   EXSR      SRValDtl
     C                   ELSE
                                                                                              233004
     C                   IF        Idx <> 0                                                   233004
     C                   EVAL      WScrn = 'C'
     C                   ELSE                                                                 233004
     C                   EVAL      WScrn = 'T'                                                233004
     C                   ENDIF                                                                233004
                                                                                              233004
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvFlDtl - Retrieve File Detail                             *
      *****************************************************************
     C     SRRtvFlDtl    BEGSR
 
     C     KEY1          KLIST
     C                   KFLD                    PNAHO
     C                   KFLD                    NSDDCTTX
 
     C     KEY1          CHAIN     SDNHTXL1
 
     C                   IF        Not %Found(SDNHTXL1)
     C     *Lock         IN        LDA
     C                   EVAL      DBKEY  =  PNAHO + DDCTTX
     C                   EVAL      DBFILE =  'SDNHTXPD'
     C                   EVAL      DBASE  =  2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValDtl - Validate Details                                   *
      *****************************************************************
     C     SRValDtl      BEGSR
 
      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear Record in File Format
 
     C                   EXSR      SRResetErr
     C                   CLEAR                   NwFilFmt
     C                   EVAL      NwFilFmt = CrFilFmt
 
      ** Validate Details
 
     C                   CALLB     'SDNATXVAL'
 
      * Input Parameters :
 
      ** Return Code
      ** Mode of Operation
      ** Response Mode
      ** New Details in Subfile Format
     C                   PARM                    RetCodeIn
     C                   PARM                    PModeOfOp
     C                   PARM                    PRespMode
     C                   PARM                    NwSflFmt
 
      * Output Parameters :
 
      ** Error Flags
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** New Details in File Format
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    NwFilFmt
 
      ** If subfile record has no errors, update file before reading
      ** next subfile record.
 
     C                   IF        Idx = 0
     C                   EVAL      WScrn = 'U'
     C                   ELSE
     C                   EVAL      WScrn = 'A'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUpdate - UPDATES                                            *
      *****************************************************************
     C     SRUpdFile     BEGSR
 
     C                   CALLB     'SDNATXUPD'
 
      * Input Parameters :
 
      ** Return Code
      ** Action Code                                                                          233295
      ** New Details in File Format
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    PActCde                                      233295
     C                   PARM                    NwFilFmt
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.  Otherwise, commit the updates
 
     C                   IF        RetCodeIn <> *BLANK And
     C                             RetCodeIn <> '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   IF        RetCodeIn = '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C
     C                   IF        RetCodeIn = '*RECUPD'
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'SDM0089'
     C                   ENDIF
 
     C                   EVAL      WScrn = 'A'
     C**********         EVAL      WUpdFlag = 'Y'                                             232543
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRResetErr - Reset error indicators                           *
      *****************************************************************
     C     SRResetErr    BEGSR
 
      ** Reset Errors fields
 
     C                   EVAL      OkFlags = *ALL'Y'
     C                   EVAL      Idx = *Zeros
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   EVAL      WRdNxBr= '0'
 
      ** Blank the screens
 
     C                   EVAL      NwSflFmt = *Blanks
 
      ** Start with the building of the subfile
 
     C                   EVAL      WScrn = 'B'
     C                   EVAL      DDNAHO = PNAHO
     C                   EVAL      PINKE = '0'
     C                   EVAL      PINKC = '0'
     C                   EVAL      PINKL = '0'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** Return Code
      ** Non-a/c Holder
     C                   PARM                    ReturnCode
     C                   PARM                    PActn
     C                   PARM                    PNAHO
     C                   PARM                    PFKey                                      BUG22582
 
      ** Initialise program name
 
     C                   MOVEL     'SDNATXSIN'   DBPGM
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PActn = 'E'
     C                   EVAL      PProtect = 'Y'
     C                   ELSE
     C                   EVAL      PProtect = *Blanks
     C                   ENDIF
 
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
(c) Finastra International Limited 2004
