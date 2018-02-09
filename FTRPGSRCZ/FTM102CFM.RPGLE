     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
 
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT FTM102CFMr Confirmation')                     *
      * ==============================================================
      *  Midas - CCT Confirmation                                     *
 
      *  FTM102CFM  - Confirm CCT records                             *
      *
      * This routine can be called interactively or from FT0300
      * to confirm and write details of the CCT transaction.
      *
      *  (c) Finastra International Limited 2001                      *
 
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      * ==============================================================
 
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 09Feb10               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15263           Date 09Nov07               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10602           Date 16Feb06               *
      *                 BUG2297            Date 28Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 25Jun03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188775             Date 08Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187211             Date 20Nov00               *
      *                 185196             Date 23Oct00               *
      *                 185107             Date 17Oct00               *
      *                 184255             Date 27Sep00               *
      *                 177674             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177674             Date 02May00               *
      *                 178384             Date 02May00               *
      *                 178186             Date 27Apr00               *
      *                 CFT006  *CREATE    Date 14Sep99               *
 
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15263 - Error upon authorisation with insufficient funds  *
      *             funds must only be a warning                      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  BUG2297- FT101HL7 already locked by job on authorise         *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  188775 - Checking for insufficient funds                     *
      *  187211   Allow outgoing Payments to be generated             *
      *  185196 - Put out warning message when authorising if routed  *
      *           from SWIFT message and not all parts processed.     *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184255 - Call Pay and Receive                                *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  177674 - Update process must be have in the same in STP      *
      *  178384 - Use the correct date in UPDDTE and convert to Midas *
      *           day number moving it in this field                  *
      *  178186 - Remove shadow postings generation                   *
      *           and duplicated COMMIT                               *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
     FFT102HL3  UF   E           K DISK    COMMIT INFSR(FileErr) InFDS(HdrDS)
     FFT102DL0  IF   E           K DISK           INFSR(FileErr) InFDS(DtlDs)
     FMEIRFTL0  IF   E           K DISK
     F* IMM Incoming Msg Control File                                           185196
     FMEINFTL0  IF   E           K DISK    INFSR(FileErr)                       185196
     F* CCT detail file                                                         185196
     FFT102DL2  IF   E           K DISK    INFSR(FileErr)RENAME(FT102DD0:RFTL2D)185196
 
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
     D HdrRcdIn      E DS                  EXTNAME(FT102HPD)
     D H_CCTAMT      E                     EXTFLD(CCTAMT)
 
      ** Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Funds Transfer Details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
                                                                                             BUG2297
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG2297
      ** External DS for SAR Details                                                         BUG2297
 
      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DtlFile       E DS                  EXTNAME(FT102DPD) PREFIX(D)
      **                                                                                     BUG2297
      ** SCCMTJOB DataArea Layout                                                            BUG2297
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG2297
     D  WDSJobs                4    103A                                                     BUG2297
      **                                                                                     BUG2297
 
      * AOSPOSU0 datastructure parameter
     DC#DTA            DS           256
     D C#ATYP                  1      1
     D*C#ACCT*                 2     19                                                       CGL029
     D*C#CNU1***               2      7  0                                                    CSD027
     D C#CNU1                  2      7                                                       CSD027
     D C#CCY1                  8     10
     D*C#ACO1*                11     14  0                                                    CGL029
     D C#ACS1                 15     16  0
     D C#BRC1                 17     19
     D C#NOSN                  2      3  0
     D C#NOS                   2      6
     D C#ACNO                  2     11  0
     D*C#CNUM***               2      7  0                                                    CSD027
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
     D*W#CNU1***               1      6  0                                             CGL029 CSD027
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
 
                                                                                178384
      ** Parameters for ZDATE1                                                  178384
     D DateIn          S              6A                                        178384
     D DaynoOut        S              5P 0                                      178384
     D DatFmt          S              1A                                        178384
     D ErrorFlag       S              1A                                        178384
                                                                                188775
      ** Parameters for FTVCKIF01                                               188775
     D PRTCD           S                   LIKE(RETCODEIN)                      188775
     D WCCTID          S                   LIKE(CCTID)                          188775
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
 
     D TotalAmt        S             15  0
     D RcdCount        S                   Like(NUMTRN)
     D P@CctId         S                   Like(CctId)
     D P@SndRef        S                   Like(SndRef)
     D P@Sndist        S                   Like(Sndist)
     D ValErrCde       S                   Like(RetCodeIn)
     D RetCodeOTP      S                   Like(RetCodeIn)
     D RespMode        S              1
     D W0ACT           S              8
 
     D Acc             S             35
     D TmpA            S                   Like(Acc)
     D SavUser         S                   Like(INUSER)
      **                                                                                     BUG2297
      ** Commitment Control Job Array                                                        BUG2297
     D WJobs           S             10A   Dim(10)                                           BUG2297
      **                                                                                     BUG2297
      ** CSC022 switchable field                                                             BUG2297
     D CSC022          S              1A                                                     BUG2297
      **                                                                                     BUG2297
      ** CSC022 work fields                                                                  BUG2297
     D WArrPtr         S              3S 0                                                   BUG2297
     D WSkpComtRolbk   S              1A                                                     BUG2297
      **                                                                                     BUG2297
 
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
     C     P@CctId       Chain     FT102HL3                           99
     C                   If        *In99 = *On
     C                   Eval      DBKey  =  P@CctId
     C                   Eval      DBFile = 'FT102HPD'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 2
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Main'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Eval      H_CCTAMT = CCTAMT
     C                   Eval      SavUser = INUSER
 
      * If aleady authorised, exit program
     C                   If        AUIN = 'Y'
     C                   Exsr      Ex@Pgm
     C                   Endif
 
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
 
      ** Following code has been start it out because before                    177674
      ** calling this module (authorisation X) we call another                  177674
      ** module which updates a second time the header in order                 177674
      ** to default the total amount                                            177674
 
      * Ensure*that*the*update user,*date*and*time*are*not*set.                 177674
      ***********************                                                   177674
     C*******************If        UPDUSR <> *Blanks      OR                    177674
     C*****************************UPDDTE <> *Zeros       OR                    177674
     C*****************************UPDTIM <> *Zeros                             177674
     C*******************Exsr      Ex@Pgm                                       177674
     C*******************Endif                                                  177674
 
      * if process = Batch,the count of records for the selected senders
      * reference must be equal to the count of the 'Number of Transaction
      * records' in file FT102DPD.
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
      *  number of records in FT102DPD and SUMAMT which must equal the
      *  sum of amounts in FT102DPD for the selected CCT Id
 
     C                   Setoff                                           99
     C                   Eval      RcdCount = *Zeros
     C                   Eval      TotalAmt = *Zeros
     C     P@CctId       Setll     FT102DL0
     C     P@CctId       Reade     FT102DL0                               99
     C                   Dow       *In99 = *Off
 
     C                   Add       1             RcdCount
     C                   Add       CCTAMT        TotalAmt
 
     C     P@CctId       Reade     FT102DL0                               99
     C                   Enddo
 
     C                   If        RcdCount <> NUMTRN
     C                   Exsr      Ex@Pgm
     C                   Endif
 
     C                   If        TotalAmt <> SUMAMT
     C                   Exsr      Ex@Pgm
     C                   Endif
                                                                                185196
      * Setll MEINFTL0 using message unique reference number                    185196
      * For all records with this MUR , is MUR + Part number assigned to this   185196
      * CCTID                                                                   185196
                                                                                185196
     C     CHMSGR        Setll     MEINFTL0                                     185196
     C     CHMSGR        Reade     MEINFTL0                               46    185196
     C     *In46         Doweq     *off                                         185196
     C                   If        FTIPRF <> P@CCTID                            185196
     C                   Exsr      Ex@Pgm                                       185196
     C                   Endif                                                  185196
                                                                                185196
      ** Now check that each message part matches with a detail record          185196
     C                   Eval      Kcctid = FTIPRF                              185196
     C                   Eval      Kcctmsg = FTMSGR                             185196
     C                   Eval      Kcctmsq = FTKPRT                             185196
                                                                                185196
     C     Kft102dl2     Setll     FT102DL2                               47    185196
                                                                                185196
     C                   If        *In47 = *off                                 185196
     C                   Exsr      Ex@Pgm                                       185196
     C                   Endif                                                  185196
                                                                                185196
     C     CHMSGR        Reade     MEINFTL0                               46    185196
     C                   Enddo                                                  185196
      * End if process is in batch mode
 
     C                   Endif
      *
 
 
      * If reached this far in process then either the confirmation
      *  process is manual OR the STP criteria have been met.
      *  Other validation MUST be carried out in the FTVxx validation
      *  modules
 
      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   MOVEL     USER          PSUSER                         CAP084
     C                   ENDIF                                                  CAP084
 
      * Ensure that the CCT is valid.
 
     C                   CallB     'FTM1026VL'
     C                   Parm                    ValErrCde
     C                   Parm                    ActionCode
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlFile
 
     C                   If        ValErrCde = '*VALERROR'
     C                   Return
     C                   Endif
                                                                                188775
      *  Check for insufficient funds                                           188775
                                                                                188775
     C**********         IF        CCTTYP = 'BO'                                     188775 BUG15263
      **********                                                                     188775 BUG15263
     C**********         CALLB     'FTVCKIF01'                                       188775 BUG15263
     C**********         PARM      *BLANKS       PRTCD                               188775 BUG15263
     C**********         PARM      P@CCTID       WCCTID                              188775 BUG15263
      **********                                                                     188775 BUG15263
     C**********         IF        PRTCD = '*NOFUNDS'                                188775 BUG15263
     C**********         RETURN                                                      188775 BUG15263
     C**********         ENDIF                                                       188775 BUG15263
      **********                                                                     188775 BUG15263
     C**********         ENDIF                                                       188775 BUG15263
 
      *  Update CCT Header Record
 
      *  Dual Authorisation
 
     C                   If        ValErrCde = '*DUALAUTH'
 
     C                   Eval      CDUAL = 'Y'
 
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
 
     C                   Update    FT102HD0
 
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
     C                   Update    FT102HD0
 
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
 
     C                   Update    FT102HD0
 
     C                   Endif
 
      ***Create*Shadow*Postings                                                 178186
      ***1.**Clear AOSPOSR0 arrays                                              178186
     C*******************If        AUIN = 'Y'   AND                             178186
     C*****************************RespMode = 'S'                               178186
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
                                                                                178186
      ***5.**Commit*CCTHDRPD*changes                                            178186
     C*******************Commit                                                 178186
     C*******************Endif                                                  178186
                                                                                187211
      * If authorising check to produce Outgoing payments                       187211
                                                                                187211
     C                   If        AUIN = 'Y'                                   187211
     C                   Exsr      Crt_102_Otpay                                187211
     C                   Endif                                                  187211
 
     C                   If        AUIN = 'Y'                                   184255
     C                   CallB     'FTC0631'                                    184255
     C                   Parm      '2'           @Type             1            184255
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
     C                   PARM      '*CLEAR'      W0ACT                        Why 8?
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
 
      * Chain the CCT Header record to obtain settlement details.
     C     P@CctId       Chain     FT102HL3                           99
     C                   If        *In99 = *On
     C                   Eval      DBKey  =  P@CctId
     C                   Eval      DBFile = 'FT102HPD'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 2
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Main'
     C                   Exsr      *PSSR
     C                   Endif
 
      *  Read ALL detail records for the CctId.  If outgoing payment NOT
      *   generated, create shadow posting.  Each detail record will have
      *   a posting.  The ordering customer / Account Servicing instution
      *   may be derived from the header record.
 
     C                   Setoff                                           99
     C     P@CctId       Setll     FT102DL0
     C     P@CctId       Reade     FT102DL0                               99
     C                   Dow       *In99 = *Off
 
     C                   Eval      C#NARR   =    CctId
 
     C                   If        GOPFLG <> 'Y'
 
      *         S E T T L E M E N T     D E T A I L S
     C                   Select
 
      * Sending Institution
     C                   When      SINSTT = 'G'  OR
     C                             SINSTT = 'R'  OR
     C                             SINSTT = 'I'  OR
     C                             SINSTT = 'F'
     C                   Eval      C#ATYP = SINSTT
     C                   Eval      TmpA   = SINST
     C                   Exsr      FmtAcc
 
      * Destination
     C                   When      DSTTYP = 'G'  OR
     C                             DSTTYP = 'R'  OR
     C                             DSTTYP = 'I'  OR
     C                             DSTTYP = 'F'
     C                   Eval      C#ATYP = DSTTYP
     C                   Eval      TmpA   = CCTDST
     C                   Exsr      FmtAcc
 
      * Header Ordering Customer
     C                   When      CUSTTH = 'R'  OR
     C                             CUSTTH = 'G'  OR
     C                             CUSTTH = 'I'  OR
     C                             CUSTTH = 'F'
     C                   Eval      C#ATYP = CUSTTH
     C                   Eval      TmpA   = TOCUS1
     C                   Exsr      FmtAcc
 
      * Header Ordering Institution
     C                   When      ORDITP = 'G'  OR
     C                             ORDITP = 'R'  OR
     C                             ORDITP = 'I'  OR
     C                             ORDITP = 'F'
     C                   Eval      C#ATYP = ORDITP
     C                   Eval      TmpA   = OINST3
     C                   Exsr      FmtAcc
 
      * Senders Correspondent
     C                   When      SNDTYP = 'G'  OR
     C                             SNDTYP = 'R'  OR
     C                             SNDTYP = 'I'  OR
     C                             SNDTYP = 'F'
     C                   Eval      C#ATYP = SNDTYP
     C                   Eval      TmpA   = SNDCOR
     C                   Exsr      FmtAcc
 
      * Detail Ordering Customer
     C                   When      CUSTTD = 'R'  OR
     C                             CUSTTD = 'G'  OR
     C                             CUSTTD = 'I'  OR
     C                             CUSTTD = 'F'
     C                   Eval      C#ATYP = CUSTTD
     C                   Eval      TmpA   = ORDCU1
     C                   Exsr      FmtAcc
 
      * Detail Ordering Institution
     C                   When      ORDITP = 'R'  OR
     C                             ORDITP = 'G'  OR
     C                             ORDITP = 'I'  OR
     C                             ORDITP = 'F'
     C                   Eval      C#ATYP = ORDITP
     C                   Eval      TmpA   = ORDI35
     C                   Exsr      FmtAcc
 
     C                   Endsl
 
      * Settlement Value Date
     C                   Eval      C#VDAT   =    DBTVDT
     C                   Eval      C#IO     =    'I'
      * Settlement Currency
     C                   Eval      C#CCY    =    CCTCCY
      * Other fields
     C                   Eval      C#TRYP   =    CCTTYP
     C                   Eval      C#PREF   =    CctId
     C                   Eval      C#AMT    =    CCTAMT
     C                   Eval      C#MOD    =    'FT'
     C                   Eval      C#OLRC   =    '01'
 
      * Determine Date
 
     C                   Select
     C                   When      D#Pdti   =  'E'                              Event Date
     C                   Eval      C#pstd   =   TTVDTE
     C                   When      D#Pdti   =  'I'
     C                   Eval      C#Pstd   =    BJRDNB
     C                   When      D#Pdti   =  'S'
     C                   If        TTVDTE   >  DBTVDT
     C                   Eval      C#Pstd   =  TTVDTE
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
      * Order for pay instructions are 1.  Receivers Correspondent,
      *  2. Account with Institution, 3. Beneficiary
 
     C                   Select
      * Receivers Correspondent
     C                   When      RCVTYP  = 'F'  OR
     C                             RCVTYP  = 'G'  OR
     C                             RCVTYP  = 'R'  OR
     C                             RCVTYP  = 'I'
     C                   Eval      C#ATYP  = RCVTYP
     C                   Eval      TmpA    = RCVCOR
     C                   Exsr      FmtAcc
 
      * Account with Institution
     C                   When      AWITP   = 'F'  OR
     C                             AWITP   = 'G'  OR
     C                             AWITP   = 'R'  OR
     C                             AWITP   = 'I'
     C                   Eval      C#ATYP  = AWITP
     C                   Eval      TmpA    = ACCI35
     C                   Exsr      FmtAcc
 
      * Beneficiary
     C                   When      BENTTD  = 'I'  OR
     C                             BENTTD  = 'G'  OR
     C                             BENTTD  = 'R'  OR
     C                             BENTTD  = 'F'
     C                   Eval      C#ATYP  = BENTTD
     C                   Eval      TmpA    = BENF1
     C                   Exsr      FmtAcc
 
     C                   Endsl
 
      * Pay Value Date
     C                   Eval      C#VDAT   =    CRDVDT
     C                   Eval      C#IO     =    'I'
      * Settlement Currency
     C                   Eval      C#CCY    =    PAYCCY
      * Other fields
     C                   Eval      C#TRYP   =    CCTTYP
     C                   Eval      C#PREF   =    CctId
     C                   Eval      C#AMT    =    PAYAMT * -1
     C                   Eval      C#MOD    =    'FT'
     C                   Eval      C#OLRC   =    '01'
 
      * Determine Date
 
     C                   Select
     C                   When      D#Pdti   =  'E'                              Event Date
     C                   Eval      C#pstd   =   TTVDTE
     C                   When      D#Pdti   =  'I'
     C                   Eval      C#Pstd   =    BJRDNB
     C                   When      D#Pdti   =  'S'
     C                   If        TTVDTE   >  CRDVDT
     C                   Eval      C#Pstd   =  TTVDTE
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
 
     C                   Else
 
      * Create outgoing payments if required.
 
     C                   CallB     'FTM10XUPO'
     C                   Parm                    RetCodeOTP
     C                   Parm                    CctId
     C                   Parm                    TrnsId
 
     C                   Endif
 
     C     P@CctId       Reade     FT102DL0                               99
 
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
     C     Crt_102_Otpay Begsr                                                  187211
                                                                                187211
      * Chain the CCT Header record to obtain settlement details.               187211
     C     P@CctId       Chain     FT102HL3                           99        187211
     C                   If        *In99 = *On                                  187211
     C                   Eval      DBKey  =  P@CctId                            187211
     C                   Eval      DBFile = 'FT102HPD'                          187211
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
     C     P@CctId       Setll     FT102DL0                                     187211
     C     P@CctId       Reade     FT102DL0                               99    187211
     C                   Dow       *In99 = *Off                                 187211
                                                                                187211
     C                   Eval      C#NARR   =    CctId                          187211
                                                                                187211
     C                   If        GOPFLG = 'Y'                                 187211
                                                                                187211
      * Create outgoing payments if required.                                   187211
                                                                                187211
     C                   CallB     'FTM10XUPO'                                  187211
     C                   Parm                    RetCodeOTP                     187211
     C                   Parm                    CctId                          187211
     C                   Parm                    TrnsId                         187211
                                                                                187211
     C                   Endif                                                  187211
                                                                                187211
     C     P@CctId       Reade     FT102DL0                               99    187211
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
      **                                                                                     BUG2297
      ** SETON LR to close empty files if SAR CSC022 is on                                   BUG2297
      **                                                                                     BUG2297
     C                   If            CSC022 = 'Y' and WSkpComtRolbk = 'Y'                  BUG2297
     C                   SETON                                        LR                     BUG2297
     C                   EndIf                                                               BUG2297
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
     C                   Parm                    P@CctId
     C                   Parm                    P@SNDREF
     C                   Parm                    P@SNDIST
 
      * <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=> <=>
      * Key Lists
     C     Ky#Meir       Klist
     C                   Kfld                    P@SNDREF
     C                   Kfld                    P@SNDIST
                                                                                185196
      ** Key list for FT102DL2                                                  185196
                                                                                185196
     C     *Like         Define    CCTID         Kcctid                         185196
     C     *Like         Define    CCTMSG        Kcctmsg                        185196
     C     *Like         Define    CCTMSQ        Kcctmsq                        185196
                                                                                185196
     C     Kft102dl2     KLIST                                                  185196
     C                   KFLD                    Kcctid                         185196
     C                   KFLD                    Kcctmsg                        185196
     C                   KFLD                    Kcctmsq                        185196
 
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
 
      **                                                                                     BUG2297
      ** Access SAR details to see if CSC022 is switched on                                  BUG2297
      **                                                                                     BUG2297
     C                   CallB     'AOSARDR0'                                                BUG2297
     C                   Parm      *Blanks       @RtCd                                       BUG2297
     C                   Parm      '*VERIFY'     @Optn                                       BUG2297
     C                   Parm      'CSC022'      PSard             6                         BUG2297
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2297
      ** Initialize CSC022 and Skip Commit Flags                                             BUG2297
     C                   Eval      CSC022 = 'N'                                              BUG2297
     C                   Eval      WSkpComtRolbk = 'N'                                       BUG2297
      **                                                                                     BUG2297
     C                   If        PRtCd = *BLANKS                                           BUG2297
     C                   Eval      CSC022 = 'Y'                                              BUG2297
      **                                                                                     BUG2297
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                     BUG2297
      **                                                                                     BUG2297
     C                   In        SCCMTJOB                                                  BUG2297
     C                   If        ComitNum > 0                                              BUG2297
      ** Move committed jobs to arrary for checking                                          BUG2297
     C                   MoveA     WDSJobs       WJobs                                       BUG2297
      ** Verify if job running exists in array                                               BUG2297
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                        BUG2297
     C                   If        WArrPtr > 0                                               BUG2297
     C                   Eval      WSkpComtRolbk = 'Y'                                       BUG2297
     C                   EndIf                                                               BUG2297
     C                   EndIf                                                               BUG2297
      **                                                                                     BUG2297
     C                   Else                                                                BUG2297
      ** Execute *PSSR if CSC022 is not found or Database error                              BUG2297
     C                   If        PRtCd <> '*NRF'                                           BUG2297
     C     *Lock         In        LDA                                                       BUG2297
     C                   Eval      DBFile = 'SCSARDPD'                                       BUG2297
     C                   Eval      DBPgm  = PSProcPgm                                        BUG2297
     C                   Eval      DBKey  = 'CSC022'                                         BUG2297
     C                   Eval      DBase  = 6                                                BUG2297
     C                   Exsr      *PSSR                                                     BUG2297
     C                   EndIf                                                               BUG2297
     C                   EndIf                                                               BUG2297
 
 
 
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
