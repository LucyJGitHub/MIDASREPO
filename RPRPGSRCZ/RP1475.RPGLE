     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Set Requested PB Customer Flag.')
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1475 - Set Requested PB Customer Flag.                     *
      *                                                               *
      *  Function:    this module allows to set up field "Requested   *
      *            PB Customer", from SD API Customer PB Details file *
      *            SDPBDSPD, for Customers that satisfy required      *
      *            selection, depending on following entry parameter  *
      *            values:                                            *
      *              - "S" (Set option) | --> update flag with "Y"    *
      *                                 |     (if Gateway option).    *
      *                                 | --> update flag with "T"    *
      *                                 |     (if Take On option).    *
      *              - "R" (Reset option) --> update flag with "N". *
      *                                                               *
      *  Component of: RPC1475 - Set Requested PB Customer Flag.      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198158             Date 24Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 13Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  198158 - Add validation on Acc. Manager and Acc. Officer     *
      *           is invalid value, then print it on new RP1475AU     *
      *           and avoid to flag customer for TakeOn.              *
      *  CPB002 - New Private Banking Customer Processing.            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  PB Wrong Setup on Customer audit report.                              198158
     FRP1475AU  O    E             Printer Infsr(*Pssr)                         198158
     F                                     OFLIND(*IN50)                        198158
     F                                     Usropn                               198158
      **  Midas SD Customer Details file.
     FSDCUSTPD  UF   E           k Disk
     F                                     INFSR(*Pssr)
 
      **  Midas SD API Customer Private Banking Details file.
     FSDPBDSL0  UF   E           K Disk
     F                                     INFSR(*Pssr)
      **  Midas SD Supplementary fields for take-on.                            198158
     FPBCUSTL0  IF   E           K Disk                                         198158
     F                                     PREFIX(X_)                           198158
     F                                     INFSR(*Pssr)                         198158
 
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  End of File SDCUSTPD.                                 *
      *  82  -  CHAIN to file SDPBDSL0 failed.                        *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * 01   02   03   04   05   06   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   xx *     *
      *       * xx   xx   53   54   55   56   57   58   59   60 *     *
      *       * 61   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * xx   xx   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   98   99      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /Space 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  #Init   - Initialization subroutine.                         *
      *  *Pssr   - Program exception error routine                    *
      *  *inzsr  - Program Initialization routine.                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D Lda           E DS           256    Extname(LDA) Dtaara(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      **  Customer Selection Data Area.
     D RPCust        E DS                  Extname(RPCUST) DTAARA(RPCUST)
 
      **  Data structure for access programs, long data structure.
     D Dssdy         E DS                  Extname(DSSDY)
      *                                                                         198158
     D SDACOF        E DS                  ExtName(SDACOFPD)                    198158
      ** EXTERNAL DATA STRUCTURES FOR ACCOUNT OFFICER DETAILS                   198158
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **-------------------- Start of Parameters --------------------**
      **  Option to run.
     D P_Option        S              1A
      **--------------------- End of Parameters ---------------------**
 
      **  Work Field used as key to access to Customer PB Details.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6A                                                      CSD027
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
      **  Work Field used to condition TakeOn for current customer              198158
     D WSelect         S              1A                                        198158
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /Eject
      *****************************************************************
     C     Start         Tag
 
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *inzsr is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
      **  Perform initialization subroutine as program remains in memory.
     C                   Exsr      #Init
     C                   Setoff                                       51        198158
 
      **  Read first customer.
     C                   Read      SDCUSTPD                               81
 
      **  Do while PB Customers to process.
     C     *in81         Doweq     False                                        Begin Do_While
 
     C                   Movel     *Blanks       P1ERROR                        198158
     C                   Eval      WSelect = 'Y'                                198158
      **  If Account Officer is not setup --> don't request for Private Customer
     C     BBACOC        Ifeq      *Blanks                                      Begin Account Off.
     C     *lock         In        RPCust
     C**********         Eval      CSRetnCode = '*Warning'                      198158
     C                   Eval      CSRetnCode = '*ErrCust'                      198158
     C                   Out       RPCust
     C                   Eval      WSelect = 'N'                                198158
     C                   Eval      P1ERROR = 'Account officer cannot be blanks' 198158
     C                   Exsr      Print                                        198158
     C                   Else                                                   198158
      *                                                                         198158
      **   Account manager code - If entered it must be valid                   198158
      *                                                                         198158
     C                   Call      'AOACOFR0'                                   198158
     C                   Parm      '*BLANKS'     @RTCD             7            198158
     C                   Parm      '*KEY   '     @OPTN             7            198158
     C                   Parm                    BBACOC                         198158
     C     SDACOF        Parm      SDACOF        Dssdy                          198158
      *                                                                         198158
     C     AZACOT        Ifeq      2                                            198158
     C     AZACOT        oreq      3                                            198158
      * Ok                                                                      198158
     C                   Else                                                   198158
     C                   Eval      P1ERROR = 'Account officer code not 2 or 3 ' 198158
     C                   Exsr      Print                                        198158
     C                   Eval      WSelect = 'N'                                198158
     C     *lock         In        RPCust                                       198158
     C                   Eval      CSRetnCode = '*ErrCust'                      198158
     C                   Eval      WSelect = 'N'                                198158
     C                   Out       RPCust                                       198158
     C                   Endif                                                  198158
      *                                                                         198158
     C                   EndIf                                                  End Account Off.
     C                                                                          198158
     C     BBCUST        CHAIN     PBCUSTL0                           52        198158
     C     *IN52         IFEQ      '1'                                          198158
     C                   Eval      P1ERROR = 'No Account manager defined '      198158
     C                   Exsr      Print                                        198158
     C                   Eval      WSelect = 'N'                                198158
     C     *lock         In        RPCust                                       198158
     C                   Eval      CSRetnCode = '*ErrCust'                      198158
     C                   Eval      WSelect = 'N'                                198158
     C                   Out       RPCust                                       198158
     C                   ENDIF                                                  198158
 
      **  Define key list to access to Customer PB Details file.
     C     K_SDPbds      Klist
     C                   Kfld                    K_CustNum
     C                   Move      BBCUST        K_CustNum
 
      **  Access to Customer PB Details file.
     C     K_CustNum     Chain     SDPBDSL0                           82
 
      **  If Customer PB Details do not exist, handle database error.
     C     *in82         Ifeq      True                                         Begin *in82
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDPBDSL0'                          ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C                   Eval      Dbkey  = BBCUST                              ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  *in82
 
      **  Update Requested PB Customer flag.
     C                   Select                                                 Begin Select
 
      **  If set option was called from Gateway option.
      *   Update files only if selected.                                        198158
     C     P_Option      Wheneq    'S'                                          Gateway
     C     *inu1         Andeq     True
     C     WSelect       Ifne      'N'                                          198158
     C                   Eval      PBREPB = 'Y'
     C                   Endif                                                  198158
 
      **  If set option was called from Take On option.
     C     P_Option      Wheneq    'S'                                          Take On
     C     *inu1         Andeq     False
     C                   Eval      PBREPB = 'T'
 
      **  If program was called to reset Requested PB Customer Flag.
     C     P_Option      Wheneq    'R'                                          Reset
     C                   Eval      PBREPB = 'N'
 
      **  If from Gateway, set flag to PB = 'Y'
     C     BBPRBA        Ifeq      'N'
     C     WSelect       Ifne      'N'                                          198158
     C                   Eval      BBPRBA = 'Y'
     C                   Eval      PBPBST = BJRDNB
     C                   Update    SDCUSTD0
     C                   Endif                                                  198158
     C                   Endif
 
     C                   Endsl                                                  End Select
 
      **  Update Customer PB details record.
     C                   Update    SDPBDSD0
 
      **  Read next PB Customer.
     C                   Read      SDCUSTPD                               81
 
     C                   Enddo                                                  End Do_While
 
      **  Close Customer Master Details file so that new set of records
      **  could be opened by using OPNQRYF command.
     C                   Close     SDCUSTPD
                                                                                198158
      **   Close report if it was opened                                        198158
     C     *IN51         Ifeq      *ON                                          198158
     C     P_Option      Andeq     'S'                                          198158
     C                   Write     TRAILP1                                      198158
     C                   Close     RP1475AU                                     198158
     C                   EndIf                                                  198158
 
      **  Exit from program.
     C                   Return
 
      /Eject                                                                    198158
      *****************************************************************         198158
      /Title SR/#Print                                                          198158
      *****************************************************************         198158
      *                                                               *         198158
      *  *Print - Output customer in not valid for TakeOn             *         198158
      *                                                               *         198158
      *  Called By: Main processing                                   *         198158
      *                                                               *         198158
      *  Calls:     None                                              *         198158
      *                                                               *         198158
      *****************************************************************         198158
                                                                                198158
     C     Print         Begsr                                                  198158** Print SR **
      *                                                                         198158
      **   If Customer not selected print it out on mode 'S'                    198158
      *                                                                         198158
     C     WSelect       Ifeq      'N'                                          198158
     C     P_Option      Andeq     'S'                                          198158
                                                                                198158
      **   Prepare output.                                                      198158
     C     *IN51         Ifeq      *OFF                                         198158
     C                   Seton                                        51        198158
     C                   Open      RP1475AU                                     198158
     C                   WRITE     HEADP1                                       198158
     C                   EndIf                                                  198158
                                                                                198158
     C                   Eval      P1CUST = BBCUST                              198158
     C                   Eval      P1CSSN = BBCSSN                              198158
     C                   WRITE     DETAIL1                                      198158
     C   50              WRITE     HEADP1                                       198158
     C                   EndIf                                                  198158
     C                   Endsr                                                  198158
      /Eject
      *****************************************************************
      /Title SR/#Init
      *****************************************************************
      *                                                               *
      *  *Init - Initialization subroutine.                           *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #Init         Begsr                                                  ** #Init SR **
 
     C     *Entry        Plist
     C                   Parm                    P_Option
 
      **  Access Bank details by using access program.
     C                   Callb     'AOBANKR0'
     C                   Parm      *blanks       P_Rtcd            7
     C                   Parm      '*FIRST '     P_optn            7
     C     Sdbank        Parm      Sdbank        Dssdy
 
 
      **  Open Customer Master Details file, set of records
      **  of which has been opened by using OPNQRYF command.
     C                   Open      SDCUSTPD                             99
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      * *Pssr  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     *Pssr         Begsr
 
     C     W_RunBefore   Ifeq      *Blank                                       Begin W_RunBefore
     C                   Move      'Y'           W_RunBefore
     C                   Dump
 
     C     *lock         In        RPCust
     C                   Eval      CSRetnCode = '*Pssr'
     C                   Out       RPCust
 
     C                   Endif                                                  End W_RunBefore
 
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
 
     C                   Endsr
 
      *****************************************************************
      /Eject
      *****************************************************************
      *                                                               *
      * *Inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *Inzsr        Begsr
 
     C                   Endsr
 
      /Eject
      *****************************************************************
**  Cpy@
(c) Finastra International Limited 2001
