     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT FTM101CFMr Confirmation')                     *
      *****************************************************************
      *                                                               *
      *  Midas - RFT Confirmation                                     *
      *                                                               *
      *  FTM101CFM  - Confirm RFT records                             *
      *                                                               *
      * This routine can be called interactively or from FT0300       *
      * to confirm and write details of the RFT transaction.          *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10602           Date 16Feb06               *
      *                 221761             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 25Jun03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187211             Date 21Nov00               *
      *                 185196             Date 23Oct00               *
      *                 185107             Date 17Oct00               *
      *                 184255             Date 27Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178384             Date 02May00               *
      *                 178186             Date 27Apr00               *
      *                 CFT006  *CREATE    Date 14Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  187211 - Allow outgoing Payments to be generated             *
      *  185196 - Put out warning message when authorising if routed  *
      *           from SWIFT message and not all parts processed.     *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184255 - Call Pay and Receive                                *
      *  178384 - Use the correct date in UPDDTE and convert to Midas *
      *           day number moving it in this field                  *
      *  178186 - Remove shadow postings generation                   *
      *           and duplicated COMMIT                               *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
     FFT101HL3  UF   E           K DISK    COMMIT INFSR(FileErr) InFDS(HdrDS)
     FFT101DL0  IF   E           K DISK           INFSR(FileErr) InFDS(DtlDs)
     FMEIRFTL0  IF   E           K DISK
     F* IMM Incoming Msg Control File                                           185196
     FMEINFTL0  IF   E           K DISK    INFSR(FileErr)                       185196
     F* RFT detail file                                                         185196
     FFT101DL4  IF   E           K DISK    INFSR(FileErr)RENAME(FT101DD0:RFTL4D)185196
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HPD)
 
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Funds Transfer Details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * AOSPOSU0 datastructure parameter
     DC#DTA            DS           256
     D C#ATYP                  1      1
     D*C#ACCT*                 2     19                                                       CGL029
     D*C#CNU1*                 2      7  0                                                    CSD027
     D C#CNU1                  2      7                                                       CSD027
     D C#CCY1                  8     10
     D*C#ACO1*                11     14  0                                                    CGL029
     D C#ACS1                 15     16  0
     D C#BRC1                 17     19
     D C#NOSN                  2      3  0
     D C#NOS                   2      6
     D C#ACNO                  2     11  0
     D*C#CNUM*                 2      7  0                                                    CSD027
     D*C#ACOD*                 8     11  0                                                    CGL029
     D C#ACSQ                 12     13  0
     D C#BRCA                 14     16
     D C#IO                   24     24
     D C#CCY                  25     27
     D C#TRYP                 28     29
     D C#NARR                 30     59
     D C#CHQN                 60     67  0
     D C#PREF                 68     82
     D C#TRN                  83     88
     D C#AMT                  89     96P 0
     D C#PRON                 97     97
     D C#OLPS                 98     98
     D C#MEMS                 99     99
     D C#RSAC                100    100
     D C#MOD                 101    102
     D C#OLRC                103    104
     D C#FTOV                105    105
     D C#VDAT                106    108P 0
     D C#PSTD                109    111P 0
     D C#PSTO                112    112
     D C#RPST                113    113
     D C#RPNB                114    116  0
     D C#RTYP                117    117
     D C#BBRN                118    120  0                                                    CGL029
     D C#ACO1                121    130  0                                                    CGL029
     D C#ACOD                131    140  0                                                    CGL029
     D C#OTR1                141    160                                                       CAP204
 
      ** Exception Reference Id/Number                                                        CLE134
     D C#XRFI                162    164                                                       CLE134
     D C#XRFN                165    174  0                                                    CLE134
 
      ** Full General Ledger - CNUM/CCY/ACOD/ACSQ                                             CGL029
     D                 DS                                                                     CGL029
     D C#ACCT                  1     24                                                       CGL029
     D*W#CNU1*                 1      6  0                                             CGL029 CSD027
     D W#CNU1                  1      6                                                       CSD027
     D W#CCY1                  7      9                                                       CGL029
     D W#ACO1                 10     19  0                                                    CGL029
     D W#ACS1                 20     21  0                                                    CGL029
     D W#BRC1                 22     24                                                       CGL029
                                                                                              CGL029
      ** Funds Transfer Contro; Date FT0005
     DD#DTA            DS           256
     DD#PDTI                   1      1
     DD#CCYI                   2      3
     DD#GLUI                   4      4
     DD#TPCI                   5      5
 
     D  W0ACT          S              8
                                                                                178384
      ** Parameters for ZDATE1                                                  178384
     D DateIn          S              6A                                        178384
     D DaynoOut        S              5P 0                                      178384
     D DatFmt          S              1A                                        178384
     D ErrorFlag       S              1A                                        178384
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D HdrDS           DS
     D  HdrStat          *STATUS
 
     D DtlDS           DS
     D  DtlStat          *STATUS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     DTotalAmt         S                   LIKE(TRNAMT)
     DRcdCount         S                   Like(NUMTRN)
     DP@RftId          S                   Like(RftId)
     DP@SndRef         S                   Like(SndRef)
     DP@Sndist         S                   Like(Sndist)
     DValErrCde        S                   Like(RetCodeIn)
     DRetCodeOTP       S                   Like(RetCodeIn)
     DRespMode         S              1
     D Acc             S             35
     D TmpA            S                   Like(Acc)
     D SavUser         S                   Like(INUSER)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Reset Work Variables
     C                   Eval      RetCodeIn  = *BlankS
 
      *  If action code not authorise / confirm, abort.
     C                   If        ActionCode <> 'X'
     C                   Exsr      Ex@Pgm
     C                   Endif
 
      *  Get Header Details
     C     P@RftId       Chain     FT101HL3                           99
     C                   If        *In99 = *On
     C                   Eval      DBKey  =  P@RftId
     C                   Eval      DBFile = 'FT101HPD'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 2
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Main'
     C                   Exsr      *PSSR
     C                   Endif
 
      * If aleady authorised, exit program
     C                   If        AUIN = 'Y'
     C                   Exsr      Ex@Pgm
     C                   Endif
 
     C                   Eval      SavUser = INUSER
 
      * if process = Batch, ensure that the STP autoconfirm flag is = 'Y'
     C                   If        RespMode = 'S'
 
     C                   Call      'AOFTFRR0'
     C                   Parm                    @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C     SDFTFR        Parm                    DSFDY
 
     C                   If        @RTCD  <> *Blanks
     C                   Eval      DBKey  =  @OPTN
     C                   Eval      DBFile = 'SDBANKPD'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 1
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Main'
     C                   Exsr      *PSSR
     C                   Endif
      * AutoConfirm flag
     C                   If        BTAFTM <> 'Y'
     C                   Exsr      Ex@Pgm
     C                   Endif
 
      * Ensure that the update user, date and time are not set.
 
     C                   If        UPDUSR <> *Blanks      OR
     C                             UPDDTE <> *Zeros       OR
     C                             UPDTIM <> *Zeros
     C                   Exsr      Ex@Pgm
     C                   Endif
 
      * if process = Batch,the count of records for the selected senders
      * reference must be equal to the count of the 'Number of Transaction
      * records' in file FT101DPD.
     C     Ky#Meir       Chain     MEIRFTL0                           99
 
     C                   If        *In99 = *On
     C                   Eval      DBKey  =  SNDREF
     C                   Eval      DBFile = 'MEIRFTPD'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 3
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Main'
     C                   Exsr      *PSSR
     C                   Endif
 
      * Got fields NUMTRN (Number of transactions which must equal the
      *  number of records in FT101DPD and SUMAMT which must equal the
      *  sum of amounts in FT101DPD for the selected RFT Id
 
     C                   Setoff                                           99
     C                   Eval      RcdCount = *Zeros
     C                   Eval      TotalAmt = *Zeros
     C     P@RftId       Setll     FT101DL0
     C     P@RftId       Reade     FT101DL0                               99
     C                   Dow       *In99 = *Off
 
     C                   Add       1             RcdCount
     C                   Add       TRNAMT        TotalAmt
 
     C     P@RftId       Reade     FT101DL0                               99
     C                   Enddo
 
     C                   If        RcdCount <> NUMTRN OR
     C                             TotalAmt <> SUMAMT
     C                   Exsr      Ex@Pgm
     C                   Endif
 
      * Setll MEINFTL0 using message unique reference number                    185196
      * For all records with this MUR , is MUR + Part number assigned to this   185196
      * RFTID                                                                   185196
                                                                                185196
     C     RHMSGR        Setll     MEINFTL0                                     185196
     C     RHMSGR        Reade     MEINFTL0                               46    185196
     C     *In46         Doweq     *off                                         185196
     C                   If        FTIPRF <> P@RFTID                            185196
     C                   Exsr      Ex@Pgm                                       185196
     C                   Endif                                                  185196
                                                                                185196
      ** Now check that each message part matches with a detail record          185196
     C                   Eval      Krftid = FTIPRF                              185196
     C                   Eval      Krftmsg = FTMSGR                             185196
     C                   Eval      Krftmsq = FTKPRT                             185196
                                                                                185196
     C     Kft101dl4     Setll     FT101DL4                               47    185196
                                                                                185196
     C                   If        *In47 = *off                                 185196
     C                   Exsr      Ex@Pgm                                       185196
     C                   Endif                                                  185196
                                                                                185196
     C     RHMSGR        Reade     MEINFTL0                               46    185196
     C                   Enddo                                                  185196
                                                                                185196
 
      * End if process is in batch mode
 
     C                   Endif
      *
 
      * If reached this far in process then either the confirmation
      *  process is manual OR the STP criteria have been met.
      *  Other validation MUST be carried out in the FTVxx validation
      *  modules. Call them HERE.
 
      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   MOVEL     USER          PSUSER                         CAP084
     C                   ENDIF                                                  CAP084
 
      * Ensure that the RFT is valid.
 
     C                   CallB     'FTM1016VL'
     C                   Parm                    ValErrCde
     C                   Parm                    ActionCode
     C                   Parm                    HdrRcdIn
 
     C                   If        ValErrCde = '*VALERROR'
     C                   Return
     C                   Endif
 
      *  Update RFT Header Record
 
      *  Dual Authorisation
 
     C                   If        ValErrCde = '*DUALAUTH'
 
     C                   Eval      RDUAL = 'Y'
 
      *  If first authorising user, only update user
 
     C                   If        AUP1 = *Blanks
 
     C                   If        RespMode = 'S'
     C                   Eval      AUP1 = '*STP'
     C                   Else
     C                   Eval      AUP1 = PSUser
     C                   Endif
 
     C*********          Eval      UPDDTE = PSRunDate                           178384
     C                   Move      PSRunDate     Datein                         178384
     C                   CALLB     'ZDATE1'                                     178384
     C                   PARM                    DateIn                         178384
     C                   PARM      *ZEROS        DaynoOut                       178384
     C                   PARM      'M'           DatFmt                         178384
     C                   PARM      *BLANKS       ErrorFlag                      178384
      *                                                                         178384
     C                   Z-ADD     DaynoOut      Upddte                         178384
      *                                                                         178384
     C                   Eval      UPDTIM = PSRunTime
 
     C                   Eval      INUSER = SavUser
 
     C                   Update    FT101HD0
 
     C                   Else
 
      *  If 2nd authorising user, record is only authorised if the 2nd user
      *  is not equal to the first authorising user
 
     C                   If        AUP1 <> PSUser
 
     C                   Eval      AUP2 = PSUser
     C**********         Eval      UPDDTE = PSRunDate                           178384
     C                   Move      PSRunDate     Datein                         178384
     C                   CALLB     'ZDATE1'                                     178384
     C                   PARM                    DateIn                         178384
     C                   PARM      *ZEROS        DaynoOut                       178384
     C                   PARM      'M'           DatFmt                         178384
     C                   PARM      *BLANKS       ErrorFlag                      178384
      *                                                                         178384
     C                   Z-ADD     DaynoOut      Upddte                         178384
      *                                                                         178384
     C                   Eval      UPDTIM = PSRunTime
     C                   Eval      AUIN = 'Y'
     C                   Update    FT101HD0
 
     C                   Endif
 
     C                   Endif
 
     C                   Else
 
      *  Not dual authorisation
 
     C                   If        RespMode = 'S'
     C                   Eval      AUP1 = '*STP'
     C                   Else
     C                   Eval      AUP1 = PSUser
     C                   Endif
 
     C*******            Eval      UPDDTE = PSRunDate                           178384
     C                   Move      PSRunDate     Datein                         178384
     C                   CALLB     'ZDATE1'                                     178384
     C                   PARM                    DateIn                         178384
     C                   PARM      *ZEROS        DaynoOut                       178384
     C                   PARM      'M'           DatFmt                         178384
     C                   PARM      *BLANKS       ErrorFlag                      178384
      *                                                                         178384
     C                   Z-ADD     DaynoOut      Upddte                         178384
      *                                                                         178384
     C                   Eval      UPDTIM = PSRunTime
 
     C                   Eval      AUIN = 'Y'
 
     C                   Update    FT101HD0
 
     C                   Endif
 
      ***Create*Shadow*Postings*if*authorised*this*time                         178186
     C*******************If        AUIN = 'Y'        AND                        178186
     C*****************************RespMode =  'S'   AND                        178186
     C*****************************PYTP = 'RI'                                  178186
      ***1.**Clear*AOSPOSR0*arrays                                              178186
     C*******************Exsr      Clr_AOSPOS                                   178186
                                                                                178186
      ***2.**Add*AOSPOSR0*data                                                  178186
     C*******************Exsr      Add_AOSPOS                                   178186
                                                                                178186
      ***3.**Update positions                                                   178186
     C*******************Exsr      Upd_AOSPOS                                   178186
                                                                                178186
      ***4.**All*OK*so*far,*so*now*commit*postings                              178186
     C*******************Exsr      Cmt_AOSPOS                                   178186
     C*******************Endif                                                  178186
                                                                                178186
      ***5.**Commit*RFTHDRPD*changes                                            178186
     C*******************Commit                                                 178186
                                                                                187211
      * If authorising ceck to produce Outgoing payments                        187211
                                                                                187211
     C                   If        AUIN = 'Y'                                   187211
     C                   Exsr      Crt_101_Otpay                                187211
     C                   Endif                                                  187211
 
     C                   If        AUIN = 'Y'                                   184255
     C                   CallB     'FTC0631'                                    184255
     C                   Parm      '1'           @Type             1            184255
     C                   Endif                                                  184255
 
 
     C                   Exsr      Ex@Pgm
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Clr_AOSPOS : Clear AOSPOS arrays                              *
      *                                                               *
      * Called by: Main.                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr_AOSPOS    Begsr
     C                   Clear                   C#DTA
     C                   CallB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*CLEAR'      W0ACT                          Why 8 ?
     C                   PARM      C#DTA         O#DTA           256
      *
     C                   If        *In90  = *On  OR
     C                             @RTCD  <> *Blanks
     C                   Eval      DBKey  =  W0ACT
     C                   Eval      DBFile = 'Shadow P'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 4
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Clr_AOSPOS'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Add_AOSPOS - Add AOSPOS data                                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Add_AOSPOS    Begsr
 
      * Chain the RFT Header record to obtain settlement details.
     C     P@RftId       Chain     FT101HL3                           99
     C                   If        *In99 = *On
     C                   Eval      DBKey  =  P@RftId
     C                   Eval      DBFile = 'FT101HPD'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 2
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Main'
     C                   Exsr      *PSSR
     C                   Endif
 
      *  Read ALL detail records for the RFTID.  If outgoing payment NOT
      *   generated, create shadow posting.  Each detail record will have
      *   a posting.  The ordering customer / Account Servicing instution
      *   may be derived from the header record.
 
     C                   Setoff                                           99
     C     P@RftId       Setll     FT101DL0
     C     P@RftId       Reade     FT101DL0                               99
     C                   Dow       *In99 = *Off
 
     C                   Eval      C#NARR   =    RFTID
 
     C                   If        GOPFLG <> 'Y'
 
      *         S E T T L E M E N T     D E T A I L S
     C                   Select
      * Account Servicing Institution
     C                   When      ASITTP = 'G'  OR
     C                             ASITTP = 'R'  OR
     C                             ASITTP = 'I'
     C                   Eval      C#ATYP = ASITTP
     C                   Eval      TmpA   = %Subst(HACSV1:2:34)
     C                   Exsr      FmtAcc
 
      * Header Ordering Customer
     C                   When      CUSTTP = 'R'  OR
     C                             CUSTTP = 'G'  OR
     C                             CUSTTP = 'F'  OR
     C                             CUSTTP = 'I'
     C                   Eval      C#ATYP = CUSTTP
     C                   If        PYTP = 'RI'
     C                   Eval      TmpA   = HOCUS1
     C                   Exsr      FmtAcc
     C                   Else
     C                   Eval      TmpA   = %Subst(HOCUS1:2:34)
     C                   Exsr      FmtAcc
     C                   Endif
 
      * Detail Ordering Customer
     C                   When      DCUSTP = 'R'  OR
     C                             DCUSTP = 'G'  OR
     C                             DCUSTP = 'F'  OR
     C                             DCUSTP = 'I'
     C                   Eval      C#ATYP = DCUSTP
     C                   If        PYTP = 'RI'
     C                   Eval      TmpA   = TOCUS1
     C                   Exsr      FmtAcc
     C                   Else
     C                   Eval      TmpA   = %Subst(TOCUS1:2:34)
     C                   Exsr      FmtAcc
     C                   Endif
     C                   Endsl
 
      * Settlement Value Date
     C                   Eval      C#VDAT   =    DBTVDT
     C                   Eval      C#IO     =    'I'
      * Settlement Currency
     C                   Eval      C#CCY    =    TRNCCY
      * Other fields
     C                   Eval      C#TRYP   =    PYTP
     C                   Eval      C#PREF   =    RFTID
     C                   Eval      C#AMT    =    TRNAMT
     C                   Eval      C#MOD    =    'FT'
     C                   Eval      C#OLRC   =    '01'
     C                   Eval      C#RPST = 'Y'
     C                   Eval      C#RPNB = 10
     C                   Eval      C#RTYP = 'D'
 
      * Determine Date
 
     C                   Select
     C                   When      D#Pdti   =  'E'                              Event Date
     C                   Eval      C#pstd   =   Exdate
     C                   When      D#Pdti   =  'I'
     C                   Eval      C#Pstd   =    BJRDNB
     C                   When      D#Pdti   =  'S'
     C                   If        Exdate   >  DBTVDT
     C                   Eval      C#Pstd   =  Exdate
     C                   Else
     C                   Eval      C#Pstd   =  Dbtvdt
     C                   Endif
     C                   Endsl
 
     C                   If        D#Glui   =  'P'
     C                   Eval      C#FTOV   =  *Blank
     C                   Else
     C                   Eval      C#FTOV   =  'Y'
     C                   Endif
 
     C                   Exsr      Do_Add_Spos
 
      *             P A Y     D E T A I L S
      * Order for pay instructions are 1.  Account with Institution,
      *  2. Intermediary,  3.  Befeficiary.
 
     C                   Select
     C                   When      AWITTP  = 'F'  OR
     C                             AWITTP  = 'I'  OR
     C                             AWITTP  = 'G'  OR
     C                             AWITTP  = 'R'
     C                   Eval      C#ATYP  = AWITTP
     C                   Eval      TmpA    = TACA35
     C                   Exsr      FmtAcc
 
     C                   When      INTTTP  = 'F'  OR
     C                             INTTTP  = 'I'  OR
     C                             INTTTP  = 'G'  OR
     C                             INTTTP  = 'R'
     C                   Eval      C#ATYP  = INTTTP
     C                   Eval      TmpA    = TINST1
     C                   Exsr      FmtAcc
 
     C                   When      BENTTP  = 'F'  OR
     C                             BENTTP  = 'I'  OR
     C                             BENTTP  = 'G'  OR
     C                             BENTTP  = 'R'
     C                   Eval      C#ATYP  = BENTTP
     C                   Eval      TmpA    = TBNA35
     C                   Exsr      FmtAcc
 
     C                   Endsl
 
      * Pay Value Date
     C                   Eval      C#VDAT   =    CRDVDT
     C                   Eval      C#IO     =    'I'
      * Settlement Currency
     C                   Eval      C#CCY    =    PAYCCY
      * Other fields
     C                   Eval      C#TRYP   =    PYTP
     C                   Eval      C#PREF   =    RFTID
     C                   Eval      C#AMT    =    PAYAMT * -1
     C                   Eval      C#MOD    =    'FT'
     C                   Eval      C#OLRC   =    '01'
     C                   Eval      C#RPST = 'Y'
     C                   Eval      C#RPNB = 10
     C                   Eval      C#RTYP = 'C'
 
      * Determine Date
 
     C                   Select
     C                   When      D#Pdti   =  'E'                              Event Date
     C                   Eval      C#pstd   =   Exdate
     C                   When      D#Pdti   =  'I'
     C                   Eval      C#Pstd   =    BJRDNB
     C                   When      D#Pdti   =  'S'
     C                   If        Exdate   >  CRDVDT
     C                   Eval      C#Pstd   =  Exdate
     C                   Else
     C                   Eval      C#Pstd   =  CRDVDT
     C                   Endif
     C                   Endsl
 
     C                   If        D#Glui   =  'P'
     C                   Eval      C#FTOV   =  *Blank
     C                   Else
     C                   Eval      C#FTOV   =  'Y'
     C                   Endif
 
     C                   Exsr      Do_Add_Spos
 
      * Create outgoing payments if required.
 
     C                   Else
 
     C                   CallB     'FTM10XUPO'
     C                   Parm                    RetCodeOTP
     C                   Parm                    RftId
     C                   Parm                    TrnsId
 
     C                   Endif
 
     C     P@RftId       Reade     FT101DL0                               99
     C                   Enddo
 
     C                   Endsr
      *****************************************************************         187211
      /EJECT                                                                    187211
      *****************************************************************         187211
      *                                                               *         187211
      * Create Outgoing Payments                                      *         187211
      *                                                               *         187211
      * Called by: Main                                               *         187211
      *                                                               *         187211
      * Calls: None                                                   *         187211
      *                                                               *         187211
      *****************************************************************         187211
     C     Crt_101_Otpay Begsr                                                  187211
                                                                                187211
      * Chain the CCT Header record to obtain settlement details.               187211
     C     P@RftId       Chain     FT101HL3                           99        187211
     C                   If        *In99 = *On                                  187211
     C                   Eval      DBKey  =  P@RftId                            187211
     C                   Eval      DBFile = 'FT101HPD'                          187211
     C                   Eval      DBPgm  = PSProcPgm                           187211
     C                   Eval      Dbase  = 2                                   187211
     C                   Eval      DBMod  = PSProcMod                           187211
     C                   Eval      DBProc = 'Main'                              187211
     C                   Exsr      *PSSR                                        187211
     C                   Endif                                                  187211
                                                                                187211
      *  Read ALL detail records for the CctId.  If outgoing payment NOT        187211
      *   generated, create shadow posting.  Each detail record will have       187211
      *   a posting.  The ordering customer / Account Servicing instution       187211
      *   may be derived from the header record.                                187211
                                                                                187211
     C                   Setoff                                           99    187211
     C     P@RftId       Setll     FT101DL0                                     187211
     C     P@RftId       Reade     FT101DL0                               99    187211
     C                   Dow       *In99 = *Off                                 187211
                                                                                187211
     C                   Eval      C#NARR   =    RftId                          187211
                                                                                187211
     C                   If        GOPFLG = 'Y'                                 187211
                                                                                187211
      * Create outgoing payments if required.                                   187211
                                                                                187211
     C                   CallB     'FTM10XUPO'                                  187211
     C                   Parm                    RetCodeOTP                     187211
     C                   Parm                    RftId                          187211
     C                   Parm                    TrnsId                         187211
                                                                                187211
     C                   Endif                                                  187211
                                                                                187211
     C     P@RftId       Reade     FT101DL0                               99    187211
                                                                                187211
     C                   Enddo                                                  187211
                                                                                187211
     C                   Endsr                                                  187211
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Upd_AOSPOS - Update AOSPOS                                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Upd_AOSPOS    Begsr
 
     C                   CallB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*UPDATE'     W0ACT
     C                   PARM      C#DTA         O#DTA           256
      *
     C                   If        *In90  = *On  OR
     C                             @RTCD  <> *Blanks
     C                   Eval      DBKey  =  W0ACT
     C                   Eval      DBFile = 'Shadow P'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 5
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Upd_AOSPOS'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Cmt_AOSPOSU0 Commit changes to shadow postings                *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Cmt_AOSPOS    Begsr
 
     C                   CallB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*COMMIT'     W0ACT
     C                   PARM      C#DTA         O#DTA           256
      *
     C                   If        *In90  = *On  OR
     C                             @RTCD  <> *Blanks
     C                   Eval      DBKey  =  W0ACT
     C                   Eval      DBFile = 'Shadow P'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 5
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Upd_AOSPOS'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Do_Add_Spos : Add the AOSPOS records                          *
      *                                                               *
      * Called by: Various.                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Do_Add_Spos   Begsr
 
     C                   CallB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*ADD   '     W0ACT
     C                   PARM      C#DTA         O#DTA           256
 
     C                   If        *In90  = *On  OR
     C                             @RTCD  <> *Blanks
     C                   Eval      DBKey  =  W0ACT
     C                   Eval      DBFile = 'Shadow P'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 4
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Do_add_Spos'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FileErr  - File Error Subroutine                              *
      *                                                               *
      * Called by: Various.                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     FileErr       Begsr
 
      * If record locked by another user, return from program.  Do not
      *  dump and do not pass GO.
 
     C                   Rolbk
     C
     C                   If        HdrStat = 01218
     C                   Exsr      EX@PGM
     C                   Endif
     C
     C                   If        DtlStat = 01218
     C                   Exsr      EX@PGM
     C                   Endif
     C
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * EX@PGM - Exit Program                                         *
      *                                                               *
      * Called by: Various.                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     EX@PGM        Begsr
     C                   Return
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FmtAcc - Formats Account into CcccccyyyAaaaBbbSe              *
      *                                                               *
      * Called by: Various                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     FmtAcc        Begsr
 
     C                   If        %Subst(TmpA:1:1) = '/'
     C                   Eval      Acc  = %Subst(TmpA:2:34)
     C                   Eval      TmpA = *Blanks
     C                   Eval      TmpA = Acc
     C                   Endif
 
     C                   If        C#ATYP = 'G'
     C**********         Eval      %Subst(Acc:1:6) = %Subst(TmpA:4:9)                         CGL029
     C**********         Eval      %Subst(Acc:7:9) = %Subst(TmpA:10:12)                       CGL029
     C**********         Eval      %Subst(Acc:10:12) = %Subst(TmpA:13:16)                     CGL029
     C**********         Eval      %Subst(Acc:14:15) = %Subst(TmpA:17:18)                     CGL029
     C**********         Eval      %Subst(Acc:16:18) = %Subst(TmpA:1:3)                       CGL029
                                                                                              CGL029
     C                   Eval      %Subst(Acc:1:6) = %Subst(TmpA:4:6)                         CGL029
     C                   Eval      %Subst(Acc:7:3) = %Subst(TmpA:10:3)                        CGL029
     C                   Eval      %Subst(Acc:10:10) = %Subst(TmpA:13:10)                     CGL029
     C                   Eval      %Subst(Acc:20:2) = %Subst(TmpA:23:2)                       CGL029
     C                   Eval      %Subst(Acc:22:3) = %Subst(TmpA:1:3)                        CGL029
 
     C                   Eval      C#ACCT = Acc
     C                   Else
     C                   Eval      C#ACCT = TmpA
     C                   Endif
                                                                                              CGL029
     C                   EVAL      C#CNU1 = W#CNU1                                            CGL029
     C                   EVAL      C#CCY1 = W#CCY1                                            CGL029
     C                   EVAL      C#ACO1 = W#ACO1                                            CGL029
     C                   EVAL      C#ACS1 = W#ACS1                                            CGL029
     C                   EVAL      C#BRC1 = W#BRC1                                            CGL029
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      * INPUTS
     C                   Parm                    RetCodeIn
      * Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
      * S=Submitted (FT0300).  A=Interactive.
     C                   Parm                    RespMode
     C                   Parm                    ActionCode
     C                   Parm                    P@RftId
     C                   Parm                    P@SNDREF
     C                   Parm                    P@SNDIST
 
      * <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=>
      * Key Lists
     C     Ky#Meir       Klist
     C                   Kfld                    P@SNDREF
     C                   Kfld                    P@SNDIST
                                                                                185196
      ** Key list for FT101DL4                                                  185196
                                                                                185196
     C     *Like         Define    RFTID         Krftid                         185196
     C     *Like         Define    RFTMSG        Krftmsg                        185196
     C     *Like         Define    RFTMSQ        Krftmsq                        185196
                                                                                185196
     C     Kft101dl4     KLIST                                                  185196
     C                   KFLD                    Krftid                         185196
     C                   KFLD                    Krftmsg                        185196
     C                   KFLD                    Krftmsq                        185196
 
      * Get FT Defaults
     C                   Call      'FT0005'
     C                   Parm                    @RTCD
     C                   Parm                    D#Dta
 
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
 
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
