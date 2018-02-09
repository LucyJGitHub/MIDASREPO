     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Time Zone Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001005 - Midas SD Time Zone Maintenance                    *
      *                                                               *
      *  Function:  This program is use to maintain records of        *
      *             Time Zone file.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD035941           Date 27Jul16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG21289           Date 02Oct08               *
      *                 BUG21081           Date 17Sep08               *
      *                 BUG20731           Date 20Aug08               *
      *                 BUG20043           Date 18Aug08               *
      *                 BUG20731           Date 20Aug08               *
      *                 BUG19484           Date 04Jul08               *
      *                 BUG19400           Date 20Jun08               *
      *                 BUG19950           Date 14Jul08               *
      *                 BUG19910           Date 10Jul08               *
      *                 BUG19849           Date 08Jul08               *
      *                 BUG19524A          Date 07Jul08               *
      *                 BUG19780           Date 03Jul08               *
      *                 BUG19762           Date 03Jul08               *
      *                 BUG19624           Date 26Jun08               *
      *                 BUG19523           Date 26Jun08               *
      *                 BUG19426           Date 22Jun08               *
      *                 BUG19363           Date 19Jun08               *
      *                 BUG19361           Date 19Jun08               *
      *                 BUG19243           Date 18Jun08               *
      *                 BUG19248           Date 17Jun08               *
      *                 BUG19143           Date 10Jun08               *
      *                 BUG19141           Date 10Jun08               *
      *                 BUG19138           Date 10Jun08               *
      *                 BUG19136           Date 11Jun08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035941 - Unable to insert record in Time zone Maintenance  *
      *             at Branch Level                                   *
      *           - Applied for MD-37089                              *
      *  BUG21289 -  Various Timezone and DST errors. Applied fixes   *
      *              21226, 21225, 21072, 21071, 21039, 21017, 21007, *
      *              21004A, 21004, 21003, 21001                      *
      *  BUG21226 -  Time Zone at branch Level - press F12 on confir- *
      *              mation screen validated the screen               *
      *  BUG21225 -  Error in Time Zone at Branch Level               *
      *  BUG21072 -  Time zone - system offset not populated for      *
      *              new branches.                                    *
      *  BUG21071 -  Time zone - when populating definition for all   *
      *              branches or all branches having location.        *
      *  BUG21039 -  Error on selection of delta time                 *
      *  BUG21004A - Deletion at System Level. Reopened               *
      *  BUG21007 -  Error in time zone selection (Recompile)         *
      *  BUG21017 - Amend time zone at system level does not update   *
      *             branch.                                           *
      *  BUG21004 - Deletion at System Level                          *
      *  BUG21003 - Time zone maintenance - Unable to Delete time zone*
      *  BUG21001 - Time zone maintenance F12 not working             *
      *  BUG21081 - Cannot Delete records at Branch Level screen.     *
      *             Applied fixes 21005 and 21002                     *
      *  BUG21005 - Time zone maintenance - Amend of Year no possible *
      *             at branch and system level.                       *
      *  BUG21002 - Time zone maintenance - Error in Amend on         *
      *             system level.                                     *
      *  BUG20731 - Zone field at Time Zone Maintenance at Zone Level *
      *             accepts blank input.                              *
      *  BUG20043 - Various errors.                                   *
      *  BUG19484 - Applied remaining part of BUG19141                *
      *  BUG19400 - Zone field is missing value. No error msg is shown*
      *  BUG19950 - Various errors                                    *
      *  BUG19910 - The trailers must be updated so the audit         *
      *             reporting can report the change.                  *
      *  BUG19849 - Start and End Time of DST added on the screen     *
      *  BUG19524A - Various Errors.(Reopened)                        *
      *  BUG19780 - System accepts non-alphanumeric value (ex: ?) in  *
      *             Time Zone Code field in "Copy"                    *
      *  BUG19762 -  At system level, list view does not reflect      *
      *              the GMT Time  (Recompile)                        *
      *  BUG19624 - Branch GMT Time is not updated after Amend        *
      *  BUG19523 - Various Error.                                    *
      *  BUG19426 - DST is "on" when the system date is still less    *
      *             than the DST Start Date.                          *
      *  BUG19363 - DST Offset should be displayed as "60" and not    *
      *             "060"                                             *
      *  BUG19361 - Branch Level: After pressing "Shift" & "F6", not  *
      *             all braches with same location code are populated *
      *  BUG19243 - Correct time format for the "Current Time at Time *
      *             Zone"                                             *
      *  BUG19248 - After pressing "Shift" + "F6", time zone was not  *
      *             applied to other branches with same location      *
      *  BUG19143 - Computation of Current Time at Time Zone and      *
      *             deleting the field System Offset at System Level  *
      *  BUG19141 - Not able to delete an existing Time Zone Code     *
      *  BUG19138 - Not able to prompt list on time zone code field.  *
      *  BUG19136 - GMT Time and GMT Delta Time Sign should be        *
      *             defaulted to "0000" and "+" respectively          *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    05 - Refresh                                               *
      *    09 - Add Record                                            *
      *    10 - Delete Record                                         *
      *    12 - Cancel                                                *
      *    14 - Branch Level Maintenance                              *
      *    15 - Branch UPDATE (All Branches)                          *
      *    16 - Branch UPDATE (Same Location code only)               *
      *    20 - System Level Maintenance / Branch UPDATE              *
      *    30 - Subfile Display                                       *
      *    31 - Subfile Clear                                         *
      *    32 - Subfile Message End                                   *
      *    33 - Error indicator                                       *
      *    36 - Subfile End                                           *
      *    37 - Protect F5, F9 function keys                          *
      *    78 - True if Midas Plus release level is equals to "MP"    *
      *    79 - Enquiry mode Indicator                                *
      *    80 - No Data To Display                                    *
      *    82 - Amend IBM code and Description                        *
      *    83 - Zone Level indicator                                  *
      *    84 - DST On / Off indicator                                *
      *    86 - System Level Maintenance                              *
      *    87 - Time Zone Level Maintenance                           *
      *    88 - Branch Level Maintenance                              *
      *    89 - Trans. Mode (False- Enquiry, True- Maintenance        *
      *    98 - Rollup Indicator                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *  SRToggleReq - Process Subfile toggle selection               *
      *  SRSystemLevel- Process screen input at System Level          *
      *  SRTZoneLevel- Process screen input at Time Zone Level        *
      *  SRInsertLevel   - Validate Level code during Insert          *
      *  SRAppLevelChg  - Apply changes based on Time zone level      *
      *  SRSytemLvlUpd - Handle System Level record update            *
      *  SRBrchLvlUpd - Handle Branch Level record UPDATE             *
      *  SRBrchRecUpd - Update branch record details                  *
      *  SRChkChange  - Check changes made at time zone details       *
      *  SRBldSfl  - Build the Subfile                                *
      *  SRLoadSfl - Load the Subfile                                 *
      *  SRDspSfl  - Display the Subfile                              *
      *  SRPrSfl   - Process the Subfile Functions                    *
      *  SRReset   - Reset the Fields                                 *
      *  SRClrSfl  - Clear the Subfile                                *
      *  SRErrDta  - Output Error Message With Data                   *
      *  SRFldVal - Validate the Data of The Fields                   *
      *  SRAmend - Amend record Subroutine                            *
      *  SRDelete - Delete the Selected Record                        *
      *  SRInsert: Insert a new record in the file                    *
      *  SRCopyRecord - Duplicate  details to a new time zone record  *
      *  SRBranchLevel - Load time zone details under branch level.   *
      *  SRValDetails - Validate screen details entered.              *
      *  SRPopScrVal - Populate screen field values for Disp/Upd      *
      *  SRInitScrVal - Initialize Screen Values (Refresh)            *
      *  SRPopHistDS - Populate history DS field values for UPDATE    *
      *  SRProcAction - Process selected action code.                 *
      *  SRCvtDt   - Convert Date via ZDATE1                          *
      *  SRGetLocalTime - Get Local or Market Time                    *
      *  SRValDetails - Validate screen fields input                  *
      *  SRValBranch - Validate branch code.                          *
      *  SRGetLocalTime - Get Local or Market Time                    *
      *  SRRecFilter - Filter Records based selection criteria        *
      *  SRSnms    - Error Meesage for No selection                   *
      *  *PSSR     - Error processing                                 *
      *  SRInit    - Initialise                                       *
      *                                                               *
      *****************************************************************
      *---------------------------------------------------------------*
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      ** Time Zone Update File
     FSDTIZOL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Time Zone Retrieval File
     FSDTIZOL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     Rename(SDTIZOD0 : SDTIZOD1)
      ** Time Zone code level file  (Update)
     FSDTZLVL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Time Zone code level file (Retrieve)
     FSDTZLVL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     Rename(SDTZLVD0 : RSDTZ_LVL1)
     F                                     COMMIT                                           BUG21226
      ** Time Zone code level file (Update)
     FSDTZLVL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(SDTZLVD0 : RSDTZ_LVL3)
     F                                     COMMIT                                           BUG21226
      *
      ** Time Zone code level file (Retrieve)
     FSDTZLVL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(SDTZLVD0 : RSDTZ_LVL5)
      ** Time Zone Level History file
     FSDTZLHL3  UF A E           K DISK    INFSR(*PSSR)
     F                                     Rename(SDTZLHD0 : RSDTLH_H3)
      ** Global Zone File                                                                   BUG19400
     FGPZONEL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG19400
      *
      ** Time Zone Maintenance History File keyed by time zone code + Year + Eff. Date
     FSDTIZHL4  UF A E           K DISK    INFSR(*PSSR)
     F                                     Rename(SDTIZHD0 : RSDTIZ_L4)
 
      *  Midas SD Branch File
     F***SDBRCHL0  UF   E        K DISK    INFSR(*PSSR)                                     MD035941
     FSDBRCHLZ  UF   E           K DISK    INFSR(*PSSR)                                     MD035941
     F                                     COMMIT                                           BUG21226
 
      *  Midas SD Market Identification code File                                           BUG19523
     FSDMICCL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG19523
      * UPD : Midas SD Branch codes update                                                  BUG19910
      *                                                                                     BUG19910
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)                                     BUG19910
     F                                     COMMIT                                           BUG19910
      *                                                                                     BUG19910
      ** Time Zone Maintenance Display File
     FSD001005DFCF   E             WORKSTN
     F                                     SFILE(SDM01005S2:RRN0 )
     F                                     INFDS(INFDS)
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically Included D-Specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The Following /COPY Line Includes The LDA Layout,
      ** And The Following Named Constants:
      **    True       Logical = True(For Indcator Processing)
      **    False      Logical = False(For Indicator Processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (The Name Of The Database
      **                         Error Handler)
      ** And The Following Variables:
      **    RunBefore  1A (For The PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The Following /COPY Line Includes All The Defined Fields In
      ** the PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End Of Automatically Included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Arrays And Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS For Access Program, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS For Access Program, Extended length.
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS Based On SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** File information data structure for external file SDDSTCPD
     D SDDSTC        E DS                  EXTNAME(SDDSTCPD)
      *
      ** File information data structure for external file SDBRCHPD
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** File information data structure for external file SDTIZHPD
     D SDHIST        E DS                  EXTNAME(SDTIZHPD)
      *
      ** File information data structure for external file SDTZLHPD
     D SDHISTDS      E DS                  EXTNAME(SDTIZHPD) Prefix(H:0)
      *
      ** File information data structure for external file SDTIZOPD
     D SDTIZODS      E DS                  EXTNAME(SDTIZOPD)
      *
      ** File information data structure for external file SDTIZOPD
     D SDTIZODS2     E DS                  EXTNAME(SDTIZOPD) Prefix(C:0)
      *
      ** File information data structure for external file SDTIZOPD
     D SDTIZODS3     E DS                  EXTNAME(SDTIZOPD) Prefix(n:0)
      *
      ** File information data structure for external file SDTZLVPD
     D SDTZLVDS      E DS                  EXTNAME(SDTZLVPD)
      *
      ** File information data structure for external file SDTZLVPD
     D TmpSDTZLV     E DS                  EXTNAME(SDTZLVPD) Prefix(L:0)
      *                                                                                     BUG19780
      ** File information data structure for external file SDTZLVPD                         BUG19780
     D SavSDTZLV     E DS                  EXTNAME(SDTZLVPD) Prefix(S:0)                    BUG19780
      *
      ** File information data structure for external file SCSARSPD
     D SCSARS        E DS                  EXTNAME(SCSARSPD)
      *
      ** DS For Indicators
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                  03     03
     D  Refresh               05     05
     D  AddRecord             09     09
     D  DltRecord             10     10
     D  Cancel                12     12
     D  BranchLevel           14     14
     D  TimeZoneLevel         16     16
     D  AllBrchUpdate         17     17
     D  LocBrchUpdate         18     18
     D  SystemLevel           20     20
     D  ConfirmUpdate         21     21
     D  ZoneLevel             22     22
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflMsgEnd             32     32
     D  ActnErr               33     33
     D  SflEnd                36     36
     D  NoData                80     80
     D  Rollup                98     98
 
     d Infds           ds
     d KeyPressed            369    369
     d Cmd_Enter       C                   Const(x'F1')
      *
      ** Define A Data Structure To Access Default Branch
     D ZMUser          DS            17
     D  PBrc                  11     13A
      *
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IndPointer      S               *   INZ(%ADDR(*IN))
     D POpt            S              1A
     D RRN0            S              4S 0
     D WLstRrn         S              4S 0
     D WSavModeInd     S              1A
     D WSelectYN       S              1A
     D WError          S              1A   INZ('N')
     D WSaveRecord     S              1A   INZ('Y')
     D WCtr            S              2S 0
     D WTmpOffset      S              4S 0
     D WTime           S               T   TIMFMT(*Hms)
     D WTime1          S              6A
     D WTime_M         S               T   TIMFMT(*Hms)                                    BUG19524A
     D WTime_H         S              6S 0 INZ(240000)                                     BUG19524A
     D WTmp            S              6A
     D WOfSt           S              3S 0 Inz(*ZEROS)
     D wTZDSTC         S                   Like(TZDSTC)
     D wTZDSTF         S                   Like(TZDSTF)
     D wTZGMTS         S                   Like(TZGMTS)
     D wTZGMT          S                   Like(TZGMT)
     D wChgType        S                   Like(THTYLC)
     D nCurrYear       S              4S 0
     D Timestamp       S             26Z
     D Ddtmechar       S              4A                                                    BUG21039
      *
      ** Parameters For ZVACTBU/ZVACTU
     D PZbr            S              3A
     D PErr            S              1P 0
      *
      ** Parameters For ZDATE1
     D PZDate          S              6A
     D PZDayNo         S              5P 0
     D PErrorFlag      S              1A
 
      * Parameters for SDMFIDTIM
     D POpType         S              2A
     D PDate1          S              6A
     D PTime1          S              6A
     D PSign1          S              1A
     D POffSet1        S              4A
     D PDate2          S              6A
     D PTime2          S              6A
     D PSign2          S              1A
     D POffSet2        S              4A
     D PBranch         S              3A
     D pDateFormatInd  S              1A
     D PMicCode        S              4A
 
      **
     D PTimeStamp      S               Z
     D PBrCd           S                   Like(PBranch)
      *                                                                                     BUG19143
     D WSwTime         S               T   INZ(*SYS)                                        BUG19143
     D                                     TIMFMT(*ISO)                                     BUG19143
     D WCwTime         S              6A                                                    BUG19143
     D nPDate1         S                   Like(PZDayNo)                                    BUG19523
     D cCurrSysSign    S                   Like(PSign1)                                     BUG21071
     D nCurrSysOffs    S              4  0                                                  BUG21071
     D ZoneSysVal      S             20A   Inz('ZoneSystemName')                            BUG20731
     D ZoneName        S             10A                                                    BUG20731
     D Upper           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                     BUG20731
     D Lower           C                   'abcdefghijklmnopqrstuvwxyz'                     BUG20731
      ** Parameters for AOSVALR0                                                            BUG20731
     D POp01           S             20A                                                    BUG20731
     D PVl01           S            200A                                                    BUG20731
     D POp02           S             20A                                                    BUG20731
     D PVl02           S            200A                                                    BUG20731
     D POp03           S             20A                                                    BUG20731
     D PVl03           S            200A                                                    BUG20731
     D POp04           S             20A                                                    BUG20731
     D PVl04           S            200A                                                    BUG20731
     D POp05           S             20A                                                    BUG20731
     D PVl05           S            200A                                                    BUG20731
     D POp06           S             20A                                                    BUG20731
     D PVl06           S            200A                                                    BUG20731
     D POp07           S             20A                                                    BUG20731
     D PVl07           S            200A                                                    BUG20731
     D POp08           S             20A                                                    BUG20731
     D PVl08           S            200A                                                    BUG20731
     D POp09           S             20A                                                    BUG20731
     D PVl09           S            200A                                                    BUG20731
     D POp10           S             20A                                                    BUG20731
     D PVl10           S            200A                                                    BUG20731
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D SflPag          C                   CONST(13)
     D Select          C                   CONST('1')
     D Amend           C                   CONST('A')
     D Enquire         C                   CONST('E')
     D Delete          C                   CONST('D')
     D Copy            C                   CONST('C')
     D Populate        C                   CONST('Y')
     D DSTProcChg      C                   CONST('P')
     D DSTFlagChg      C                   CONST('F')
     D DSTCodeChg      C                   CONST('C')
     D DTZDateChg      C                   CONST('D')
     D SystemChg       C                   CONST('S')
     D BranchChg       C                   CONST('B')
     D GMTDTSChg       C                   CONST('G')
      * Invalid Characters for Timezone.                                                    BUG19780
     D InvalidChar     C                   '!@#$%¢&*()+_-=?<>,;:{}|\/"''`~'                 BUG19780
      *  SRZoneLevel- Process screen input at Zone Level              *
     D cDDGMT          S              4A                                                    BUG20043
      *
      ** Parameter For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenTabFld      S              3P 0
     D PLenScrFld      S              3P 0
     D PTranslate      S              1A   INZ('1')
     D PTrim           S              1A   INZ('1')
     D PWild           S              1A   INZ('?')
     D PResult         S              3P 0
      *
      ** Parameter For ZA0350
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A
      *
      ** Variable Declaration
     D WRun            S              1A
     D WIdx            S              3P 0
     D WCCod           S                   LIKE(H@TZCOD)
     D WCYear          S                   LIKE(H@TZYR)
     D WLocCode        S                   LIKE(A8LCCD)
     D WCurrentLevel   S                   LIKE(TLTZLC) Inz('T')
 
     D S1TZTZLC        S                   LIKE(TLTZLC)
     D S1TZZONE        S                   LIKE(TLZONE)
     D D@TZTZLC        S                   LIKE(TLTZLC)
     D D@TZZONE        S                   LIKE(TLZONE)
     D HistUpdFlag     S              1A
     D RecUpdFlag      S              1A
     D EndPGMFlag      S              1A
      *
      ** Parameters for Y2SNMGC
     D PZAPgm          S             10A
     D PZAPgrl         S              5A
     D PZAMsid         S              7A
     D PZAMsgf         S             10A
     D PZAMsda         S            132A
     D PZAMstp         S              7A
      *
      ** +--------------------------------------+
      ** ¦ End Of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      **+--- Start of Main Processing --------------------------------+
      **|                                                             ¦
      **¦ Initial Processing Is Performed Automatically: The *INZSR   ¦
      **¦ Is Executed At Program Activation.                          ¦
      **¦                                                             ¦
      **+-------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN - Processing                                             *
      *****************************************************************
      *
      ** Check if in Enquiry Mode
      *
     C                   IF        PMode = 'M'
     C                   EVAL      *IN89 = True
     C                   ELSE
     C                   EVAL      *IN89 = False
     C                   EVAL      *In37 = True
     C                   ENDIF
     C                   EVAL      WSavModeInd = *In89
      *
      ** Initialize
      *
     C                   EXSR      SRInit
      *
      ** Build the Subfile
      *
     C                   EXSR      SRBldSfl
      *
      ** Display the Screen Untill F12 or F3 Is Pressed
      *
     C                   EVAL      *IN87 = True
      *
     C                   Dow       (Exit = False) AND
     C                             (EndPGMFlag =False)
      *
      ** Display And Process the Subfile
      *
     C                   EXSR      SRDspSfl
      *
      ** Process the Subfile
      *
     C                   EXSR      SRProcess
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = True
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Main Line Program                                 *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode             1
      *
      ** Call The Access Object AOBANKR0
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
      *
     C                   IF        PRtcd <> *BLANKS
 
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Call The Access Object AOSARSR0 to check if release level is for Midas Plus
      *
     C                   CALL      'AOSARSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      'CSW208'      PSars            10
     C     SCSARS        PARM      SCSARS        DSFDY
      *
      ** Check the Return Parameter
      *
     C                   IF        PRtcd = *BLANKS
      *
     C                   IF        %Subst(AXRELL:1:2) = 'MP'
     C                   EVAL      *IN78 = True
     C                   ELSE
     C                   EVAL      *IN78 = False
     C                   ENDIF
     C
     C                   ENDIF
      *                                                                                     BUG20731
      ** Call AOSVALR0 to get the Current Zone.                                             BUG20731
      *                                                                                     BUG20731
     C                   CALL      'AOSVALR0'                                               BUG20731
     C                   PARM      *BLANKS       PRtcd                                      BUG20731
     C                   PARM      ZoneSysVal    POp01                                      BUG20731
     C                   PARM      *BLANKS       PVl01                                      BUG20731
     C                   PARM      *BLANKS       POp02                                      BUG20731
     C                   PARM      *BLANKS       PVl02                                      BUG20731
     C                   PARM      *BLANKS       POp03                                      BUG20731
     C                   PARM      *BLANKS       PVl03                                      BUG20731
     C                   PARM      *BLANKS       POp04                                      BUG20731
     C                   PARM      *BLANKS       PVl04                                      BUG20731
     C                   PARM      *BLANKS       POp05                                      BUG20731
     C                   PARM      *BLANKS       PVl05                                      BUG20731
     C                   PARM      *BLANKS       POp06                                      BUG20731
     C                   PARM      *BLANKS       PVl06                                      BUG20731
     C                   PARM      *BLANKS       POp07                                      BUG20731
     C                   PARM      *BLANKS       PVl07                                      BUG20731
     C                   PARM      *BLANKS       POp08                                      BUG20731
     C                   PARM      *BLANKS       PVl08                                      BUG20731
     C                   PARM      *BLANKS       POp09                                      BUG20731
     C                   PARM      *BLANKS       PVl09                                      BUG20731
     C                   PARM      *BLANKS       POp10                                      BUG20731
     C                   PARM      *BLANKS       PVl10                                      BUG20731
      *                                                                                     BUG20731
     C                   IF        PRtcd <> *BLANKS                                         BUG20731
     C                   EVAL      DBFile = 'SDSVALPD'                                      BUG20731
     C                   EVAL      DBase = 17                                               BUG20731
     C                   EVAL      DBKey = POp01                                            BUG20731
     C                   EXSR      *PSSR                                                    BUG20731
     C                   ENDIF                                                              BUG20731
      *                                                                                     BUG20731
     C                   MOVEL     PVl01         ZoneName                                   BUG20731
     C                   Eval      ZoneName = %XLATE(Lower : Upper :Zonename)               BUG20731
      *
      ** GET ZMUser To Access Default Branch
      *
     C     *DTAARA       DEFINE                  ZMUser
     C                   IN        ZMUser
     C                   UNLOCK    ZMUser
      *
      ** Define Key List for SDTIZOL1
      *
     C     KSdtizoL1     KLIST
     C                   KFLD                    S1TZCOD
     C                   KFLD                    S1TZYR
 
     C     KSdtizoL1A    KLIST
     C                   KFLD                    D@TZCOD
     C                   KFLD                    D@TZYR
      *
      ** Define Key List for SDTIZOL1 - Branch Level validation
      *
     C     KSBranch      KLIST
     C                   KFLD                    WCurrentLevel
     C                   KFLD                    S1TZZONE
     C                   KFLD                    S1BRCH
      *
      ** Define Key List for SDTIZOL0
      *
     C     KSdtzlvL0     KLIST
     C                   KFLD                    D@TZLCD
     C                   KFLD                    D@ZONE
     C                   KFLD                    D@BRCA
     C                   KFLD                    D@TZYR
     C                   KFLD                    D@TZCOD
      *
      ** Define Key List for SdtzlvL0A
      *
     C     KSdtzlvL0A    KLIST
     C                   KFLD                    D@TZLCD
     C                   KFLD                    D@ZONE
     C                   KFLD                    D@BRCA
     C                   KFLD                    D@TZYR
      *
      ** Define Key List for SDTZLVL1
      *
     C     KSdtzlvL1     KLIST
     C                   KFLD                    WCurrentLevel
     C                   KFLD                    S1ZONE
     C                   KFLD                    S1BRCH
     C                   KFLD                    S1TZYR
      *
      ** Define Key List for SDTZLVL0
      *
     C     KTZoneYear    KLIST
     C                   KFLD                    S1TZCOD
     C                   KFLD                    S1TZYR
      *
      ** Define Key List for SDTZLVL3
      *
     C     KSdtzlvl3     KLIST
     C                   KFLD                    D@TZLCD
     C                   KFLD                    D@BRCA
     C                   KFLD                    D@TZYR
     C     KSdtzlvl3A    KLIST                                                              BUG19780
     C                   KFLD                    D@TZLCD                                    BUG19780
     C                   KFLD                    D@BRCA                                     BUG19780
      *
      ** Define Key List for SDTIZHL4
      *
     C     KTZHist_T     KLIST
     C                   KFLD                    D@TZCOD
     C                   KFLD                    D@TZYR
     C                   KFLD                    BJRDNB
      *
      ** Define Key List for SDTZLHL3
      *
     C     KTLHIST_L     KLIST
     C                   KFLD                    TLTZLC
     C                   KFLD                    TLBRCA
     C                   KFLD                    TLLCD
      *
      ** Populate WorkStation ID
      *
     C                   EVAL      D0WID = PsJobName
      *
      ** Populate User
      *
     C                   EVAL      D0USER = PsUser
      *
      ** Populate Midas Run Date
      *
     C                   EVAL      D0MRDT = BJMRDT
      *
      ** Initialise Subfile Program Queue and Message File
      *
     C                   EVAL      D1PGMQ = '*'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
      *
      ** Message Subfile Indicator
      *
     C                   EVAL      SflMsgEnd = True
      *
      ** Program Termination Flag
     c*
     C                   EVAL      EndPGMFlag = False
      *
      ** Get the Current Year
     c*
     C                   MOVE      BJRDNB        MidasDayNo
     C                   EXSR      SRCvtDt2
     C                   Z-ADD     *ZEROS        nCurrYear         4 0
     C                   IF        PDateOut > 0
     C                   IF        BJDFIN  = 'D'
     C                   EVAL      nCurrYear = %Subdt(%Date(PDateOut:*DMY) :
     C                                         *Years)
     C                   ELSE
     C                   EVAL      nCurrYear = %Subdt(%Date(PDateoUt:*MDY) :
     C                                         *Years)
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      nCurrYear     cCurrYear         4
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *                                                               *
      *  Called by: MAIN Processing, SRProcess                        *
      *                                                               *
      *  Calls: SRClrSfl, SRLoadSfl, SRProcess, SRToggleReq           *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSfl      BEGSR
      *
      ** Clear Program Queue And Message File
      *
     C                   CALL      'ZA0250'
      *
      ** Clear the Subfile
      *
     C                   EXSR      SRClrSfl
      *
      ** Load the Subfile
      *
     C                   IF        WCurrentLevel <> 'T'
     C                   EXSR      SRLoadSfl
     C                   ELSE
     C                   EXSR      SRTLoadSfl
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspSfl - Display the Subfile                               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDspSfl      BEGSR
      *
     C                   TIME                    D0TIME
      *
      ** Write the Footer
      *
     C                   WRITE     SDM01005F1
      *
      ** WRITE the Message Subfile Control Format
      *
     C                   WRITE     SDM01005C1
      *
      ** Display the Subfile
      *
     C                   EXFMT     SDM01005C2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRReset, SRBldSfl, SRLoadSfl, SRPrSfl,                *
      *         SRsnms,  SRBranchLevel, SrSystemLevel, SRInsert,      *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
      ** Reset the Fields and the Program Message Queue
     C                   EXSR      SRReset
      *
     C                   IF        H@TZCOD = *BLANKS
     C                   EVAL      WCCod = *BLANKS
     C                   ENDIF
      *
     C                   IF        H@TZYR = *BLANKS
     C                   EVAL      WCYear = *BLANKS
     C                   ENDIF
      *
     C                   SELECT
      *
      ** When F3 Is Pressed (Exit)
      *
     C                   WHEN      Exit = True
     C                   EVAL      EndPGMFlag = True
      *
     C                   LEAVESR
      *
      ** When F5 Is Pressed (Refresh)
      *
     C                   WHEN      Refresh = True
      ** Reset and Build
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
      *
      ** When F9 Is Pressed (Insert)
      *
     C                   WHEN      AddRecord = True
     C                   EXSR      SRInsert
      *
      ** When F14 Is Pressed (Branch Level)
      *
     C                   WHEN      BranchLevel = True
     C                   SETOFF                                       838687
     C                   EVAL      *In88 = True
     C                   EXSR      SRBranchLevel
     C                   EVAL      *In88 = False
      *
      ** When F16 Is Pressed (Time Zone Level)
      *
     C                   WHEN      TimeZoneLevel = True
     C                   SETOFF                                       838688
     C                   EVAL      *In87 = True
     C                   EXSR      SRTZoneLevel
     C                   EVAL      *In87 = False
      *
      ** When F20 Is Pressed (System Level)
      *
     C                   WHEN      SystemLevel = True
     C                   SETOFF                                       838788
     C                   EVAL      *In86 = True
     C                   EXSR      SRSystemLevel
     C                   EVAL      *In86 = False
      *
      ** When F22 Is Pressed (Zone Level)
      *
     C                   WHEN      ZoneLevel = True
     C                   SETOFF                                       868788
     C                   EVAL      *In83 = True
     C                   EXSR      SRZoneLevel
     C                   EVAL      *In83 = False
      *
      ** When Page Down Is Pressed
      *
     C                   WHEN      Rollup = True
      *
      ** Load the Next Page
      *
     C                   IF        WCurrentLevel <> 'T'
     C                   EXSR      SRLoadSfl
     C                   ELSE
     C                   EXSR      SRTLoadSfl
     C                   ENDIF
 
     C                   WHEN      (H@TZCOD <> *BLANKS) OR
     C                             (H@TZYR  <> *BLANKS) OR
     C                             (H@SDES  <> *BLANKS) OR
     C                             (H@GMT   <> *BLANKS) OR
     C                             (H@GMTS  <> *BLANKS) OR                                  BUG19523
     C                             (H@DSTC  <> *BLANKS)
 
     C                   EXSR      SRPrSfl
 
     C                   IF        WError = 'N'
     C                   EVAL      WCCod  = H@TZCOD
     C                   EVAL      WCYear = H@TZYR
      *
      ** Build the Subfile With the Selection Criteria
      *
     C                   EXSR      SRBldSfl
 
     C                   ENDIF
 
     C                   OTHER
      *
      ** Process the Subfile
      *
     C                   EXSR      SRPrSfl
      *
     C                   ENDSL
      *
      ** Build the Subfile to reflect newly inserted record(s).
      *
     C                   IF        Rollup = False And EndPGMFlag = False
     C                   EXSR      SRBldSfl
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRToggleReq - Process Subfile toggle selection               *
      *                                                               *
      *  Called by: SrBranchLevel                                     *
      *                                                               *
      *  Calls: SRReset, SRSnms, SRBldSfl, SRInsert, SRLoadSfl        *
      *         SRPrSfl,                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRToggleReq   BEGSR
      *
      ** Reset the Fields and the Program Message Queue
      *
     C                   EXSR      SRReset
      *
     C                   IF        H@TZCOD = *BLANKS
     C                   EVAL      WCCod = *BLANKS
     C                   ENDIF
      *
     C                   IF        H@TZYR = *BLANKS
     C                   EVAL      WCYear = *BLANKS
     C                   ENDIF
      *
     C                   SELECT
      *
      ** When F3 Is Pressed
      *
     C                   WHEN      Exit = True
     C                   EVAL      EndPGMFlag = True
     C                   LEAVESR
      *
      ** When F5 Is Pressed
      *
     C                   WHEN      Refresh = True
 
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
      *
      ** When F9 Is Pressed
      *
     C                   WHEN      AddRecord = True
     C                   EXSR      SRInsert
      *
      ** When F14 Is Pressed (Toggle Branch Level)
      *
     C                   WHEN      BranchLevel = True
     C                   EVAL      WCurrentLevel = 'B'
     C                   EVAL      *IN88 = True
     C                   EVAL      Exit  = True
     C                   LEAVESR
      *
      ** When F16 Is Pressed (Toggle Time Zone)
      *
     C                   WHEN      TimeZoneLevel = True
     C                   EVAL      WCurrentLevel = 'T'
     C                   EVAL      *IN87 = True
     C                   EVAL      Exit  = True
     C                   LEAVESR
      *
      ** When F20 Is Pressed ((Toggle System Level)
      *
     C                   WHEN      SystemLevel = True
     C                   EVAL      WCurrentLevel = 'S'
     C                   EVAL      *IN89 = True
     C                   EVAL      *IN86 = True
     C                   EVAL      Exit  = True
     C                   LEAVESR
      *
      ** When F22 Is Pressed ((Toggle Zone Level)
      *
     C                   WHEN      ZoneLevel = True
     C                   EVAL      WCurrentLevel = 'Z'
     C**                 EVAL      *IN83 = True
     C                   EVAL      *IN86 = True
     C                   EVAL      Exit  = True
     C                   LEAVESR
 
      ** When Page Down Is Pressed
     C                   WHEN      Rollup = True
      *
      ** Load the Next Page
      *
     C                   EXSR      SRLoadSfl
     C                   WHEN      (H@TZCOD <> *BLANKS) OR
     C                             (H@TZYR  <> *BLANKS)
      *
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError = 'N'
     C                   EVAL      WCCod  = H@TZCOD
     C                   EVAL      WCYear = H@TZYR
      *
      ** Build the Subfile With the Selection Criteria
      *
     C                   EXSR      SRBldSfl
      *
     C                   ENDIF
      *
     C                   OTHER
      *
      ** Process the Subfile
      *
     C                   EXSR      SRPrSfl
      *
     C                   ENDSL
 
     C                   IF        Rollup = False And EndPGMFlag = False                    BUG20043
     C                   EXSR      SRBldSfl
     C                   ENDIF                                                              BUG20043
 
     C                   ENDSR
      *                                                                                     BUG19523
      *****************************************************************                     BUG19523
      /EJECT                                                                                BUG19523
      *****************************************************************                     BUG19523
      *                                                               *                     BUG19523
      *  SRCopyRecord - Duplicate  details to a new time zone record  *                     BUG19523
      *                                                               *                     BUG19523
      *  Called by: SRCopyRecord                                      *                     BUG19523
      *                                                               *                     BUG19523
      *  Calls: SRPopScrVal, SRReset, SRFldVal, SRInsertLevel         *                     BUG19523
      *                                                               *                     BUG19523
      *****************************************************************                     BUG19523
      *                                                                                     BUG19523
     C     SRCopyRecord  BEGSR                                                              BUG19523
     C                   EXSR      SRPopScrVal                                              BUG19523
     C                   Reset                   SDM01005D1                                 BUG19523
                                                                                            BUG19523
     C**********         EVAL      S1TZCOD = *Blanks                               BUG19523 BUG19780
     C**********         EVAL      S1ZONE  = *Blanks                               BUG19523 BUG20731
     C                   EVAL      S1ZONE  = ZoneName                                       BUG20731
     C**********         EVAL      S1TZYR  = *Blanks                               BUG19523 BUG19780
     C                   EVAL      S1TZCOD = TZTZCD                                         BUG19780
     C                   EVAL      S1TZYR  = TZYEAR                                         BUG19780
     C                   EVAL      S1BRCH  = *Blanks                                        BUG19523
                                                                                            BUG19523
     C                   EXSR      SRReset                                                  BUG19523
     C                   SETON                                        8931                  BUG19523
     C                   IF        Widx = 0                                                 BUG19780
     C                   EXSR      SRGetLocalTime                                           BUG19780
     C                   ENDIF                                                              BUG19780
                                                                                            BUG19523
     C                   WRITE     SDM01005F0                                               BUG19523
                                                                                            BUG19523
     C                   DOW       Exit = False And Cancel = False                          BUG19523
                                                                                            BUG19523
     C                   WRITE     SDM01005C1                                               BUG19523
     C                   EXFMT     SDM01005D1                                               BUG19523
     C                   EXSR      SRReset                                                  BUG19523
      *                                                                                     BUG19523
     C                   EVAL      WIdx = 0                                                 BUG19523
     C                   EXSR      SRFldVal                                                 BUG19523
      *                                                                                     BUG19523
     C                   IF        WIdx = 0                                                 BUG19523
      *                                                                                     BUG19523
     C                   EXSR      SRGetLocalTime                                           BUG19780
     C                   CALL      'ZA0250'                                                 BUG19523
     C     KSdtizoL1     CHAIN(N)  SDTIZOL0                                                 BUG19523
      *                                                                                     BUG19523
     C                   IF        Not %Found(SDTIZOL0)                                     BUG19523
     C                   EVAL      S2TZCOD = S1TZCOD                                        BUG19523
     C                   EVAL      S2TZYR  = S1TZYR                                         BUG19523
     C                   EVAL      S2BRCH  = S1BRCH                                         BUG19523
                                                                                            BUG19523
     C                   EXSR      SRInsertLevel                                            BUG19523
                                                                                            BUG19523
     C                   ELSE                                                               BUG19523
                                                                                            BUG19523
     C                   EVAL      PMsgId = 'SWF0023'                                       BUG19523
     C                   EVAL      WIdx = WIdx + 1                                          BUG19523
     C                   EVAL      *IN50 = True                                             BUG19523
     C                   EXSR      SRErrDta                                                 BUG19523
                                                                                            BUG19523
     C                   ENDIF                                                              BUG19523
      *                                                                                     BUG19523
     C                   ENDIF                                                              BUG19523
                                                                                            BUG19523
     C                   ENDDO                                                              BUG19523
                                                                                            BUG19523
     C                   SETOFF                                       3188                  BUG19523
     C                   EVAL      *IN89 = WSavModeInd                                      BUG19523
     C                   IF        Exit = True                                              BUG19523
     C                   EVAL      EndPGMFlag = True                                        BUG19523
     C                   ENDIF                                                              BUG19523
                                                                                            BUG19523
     C                   ENDSR                                                              BUG19523
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBranchLevel - Load time zone details under branch level.   *
      *                                                               *
      *  Called by: SRProcess, SRToggleReq                            *
      *                                                               *
      *  Calls: SRReset, SRBldSFL, SRDspSfl, SRToggleReq              *
      *                                                               *
      *****************************************************************
      *
     C     SRBranchLevel Begsr
 
     C                   EVAL      WCurrentLevel = 'B'
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
     C                   Dow       Exit = False
 
     C                   EXSR      SRDspSfl
 
     C                   EXSR      SRToggleReq
 
     C                   ENDDO
 
     C                   IF        EndPGMFlag = False
     C                   EVAL      *IN89 = WSavModeInd
     C                   EVAL      Exit = False
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
     C                   ENDIF
     C
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSystemLevel- Process screen input at System Level          *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRInsert, SRPopScrVal, SRAmend, SRReset, SRBldSfl,    *
      *                                                               *
      *****************************************************************
      *
     C     SRSystemLevel BegSR
 
     C                   EVAL      WCurrentLevel = 'S'
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
 
     C                   Dow       Exit = False
 
     C                   EXSR      SRDspSfl
 
     C                   EXSR      SRToggleReq
 
     C                   ENDDO
 
     C                   If        EndPGMFlag = False
     C                   EVAL      *IN89 = WSavModeInd
     C                   EVAL      Exit = False
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
     C                   Endif
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTZoneLevel- Process screen input at Time Zone Level        *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRInsert, SRPopScrVal, SRAmend, SRReset, SRBldSfl,    *
      *                                                               *
      *****************************************************************
      *
     C     SRTZoneLevel  BegSR
 
     C                   EVAL      WCurrentLevel = 'T'
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
 
     C                   Dow       Exit = False
 
     C                   EXSR      SRDspSfl
 
     C**                 EXSR      SRProcess
     C                   EXSR      SRToggleReq
 
     C                   ENDDO
 
     C                   If        EndPGMFlag = False
     C                   EVAL      *IN89 = WSavModeInd
     C                   EVAL      Exit = False
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
     C                   Endif
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZoneLevel- Process screen input at Zone Level              *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRInsert, SRPopScrVal, SRAmend, SRReset, SRBldSfl,    *
      *                                                               *
      *****************************************************************
      *
     C     SRZoneLevel   BegSR
 
     C                   EVAL      WCurrentLevel = 'Z'
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
 
     C                   Dow       Exit = False
 
     C                   EXSR      SRDspSfl
 
     C                   EXSR      SRToggleReq
 
     C                   ENDDO
 
     C                   If        EndPGMFlag = False
     C                   EVAL      *IN89 = WSavModeInd
     C                   EVAL      Exit = False
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
     C                   Endif
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset - Reset the Fields                                   *
      *                                                               *
      *  Called by: MAIN Processing, SRProcess, SRToggleReq           *
      *             SRSystemLevel, SRInsertLevel, SRAmend             *
      *                                                               *
      *  Calls: ZA0250                                                *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
     C                   EVAL      WIdx = 0
      *
     C                   IF        Refresh = True
      *
      ** Reset Search Fields
      *
     C                   EVAL      H@TZCOD = *Blanks
     C                   EVAL      H@TZYR  = *Blanks
     C                   EVAL      H@SDES  = *Blanks
     C                   EVAL      H@GMT   = *Blanks
     C                   EVAL      H@GMTS  = *Blanks                                        BUG19523
     C                   EVAL      H@DSTC  = *Blanks
     C                   EVAL      WCCod   = *Blanks
     C                   EVAL      WCYear  = *Blanks
      *
     C                   ENDIF
 
     C                   EVAL      *IN50 = False
     C                   EVAL      *IN51 = False
     C                   EVAL      *IN52 = False
     C                   EVAL      *IN53 = False
     C                   EVAL      *IN54 = False
     C                   EVAL      *IN55 = False
     C                   EVAL      *IN56 = False
     C                   EVAL      *IN57 = False
     C                   EVAL      *IN84 = False
     C                   EVAL      PMsgId   = *Blanks
     C                   EVAL      PMsgData = *Blanks
     C                   EVAL      WIdx = *ZEROS
     C                   EVAL      D0MRDT = BJMRDT
     C                   TIME                    D0TIME
     C
      *
      ** Clear Program Queue And Message File
      *
     C                   CALL      'ZA0250'
      *
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSfl - Clear The SubFile                                 *
      *                                                               *
      *  Called by: SRBldSfl                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRClrSfl      BEGSR
      *
      ** Set Pointer To First Record Of Database
     C                   IF        WCurrentLevel = 'T'
     C     *LOVAL        SETLL     SDTIZOL0
     C                   ELSE
     C     *LOVAL        SETLL     SDTZLVL0
     C                   ENDIF
      *
      ** Intialise Fields
     C                   EVAL      WError = 'N'
     C                   EVAL      RRN0 = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      D0OPT = *BLANKS
     C                   EVAL      NoData = False
     C                   EVAL      ActnErr = False
     C                   EVAL      SflClr = True
 
     C                   WRITE     SDM01005C2
 
     C                   EVAL      SflClr = False
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSfl - Load the subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl, SRProcess, SRToggleReq                  *
      *                                                               *
      *  Calls: SRErrDta, SRRecFilter                                 *
      *                                                               *
      *****************************************************************
     C     SRLoadSfl     BEGSR
      *
      ** Intialise Filter Flags - No Search Criteria
     C                   EVAL      WSelectYN = 'Y'
      *
      ** If Relative Record Number Of The Last Record Loaded In The
      ** Subfile Is Greater Than Zero
      *
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      RRN0 = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
     C                   ENDIF
      *
      ** Reset Counter
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
     C                   Dow       WCtr < SflPag And
     C                             Not %Eof(SDTZLVL0)
      *
      ** Read the Time Zone level file
     C                   READ      SDTZLVL0
      *
     C                   IF        %EOF(SDTZLVL0)
     C                   Leave
     C                   ENDIF
      *
     C                   IF        Not %Eof(SDTZLVL0)  AND
     C                             TLTZLC = WCurrentLevel
     C                   EVAL      D@TZLCD  = TLTZLC
     C                   EVAL      D@ZONE   = TLZONE
     C                   EVAL      D@BRCA   = TLBRCA
     C                   EVAL      D@TZCOD  = TLTZCD
     C                   EVAL      D@TZYR   = TLYEAR
     C     KSdtizoL1A    CHAIN(N)  SDTIZOL0
     C                   IF        NOT %FOUND(SDTIZOL0)
     C     D@TZCOD       CHAIN(N)  SDTIZOL0
     C                   ENDIF
     C                   IF        %FOUND(SDTIZOL0)
     C                   EVAL      D@STDES  = TZSDSC
     C                   MOVEL     TZGMT         D@DTIME
     C                   EVAL      D@GMTS   = TZGMTS
     C                   EVAL      D@DSTCD  = TZDSTC
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WCurrentLevel = 'B'
     C                   EVAL      D@ZONE1 = TLBRCA
     C                   WHEN      WCurrentLevel = 'Z'
     C                   EVAL      D@ZONE1 = TLZONE
     C                   OTHER
     C                   EVAL      D@ZONE1 = *BLANKS
     C                   ENDSL
      *
      ** Check for any filter
      *
     C                   EXSR      SRRecFilter
      *
      ** WRITE the Selected Records
      *
     C                   IF        WSelectYN = 'Y'
     C                   EVAL      RRN0 = RRN0 + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      D0OPT = *BLANKS
     C                   EVAL      ActnErr = False
     C                   WRITE     SDM01005S2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check For Last Record for Switching On the SFLEND Indicator
      *
     C                   IF        %EOF(SDTZLVL0)
     C                   EVAL      SflEnd = True
     C                   Else
     C                   EVAL      SflEnd = False
     C                   ENDIF
      *
      ** Check If Records are Written Into Subfile
      *
     C                   IF        WLstRrn <> 0
     C                   EVAL      SflDsp = True
     C                   Else
      *
      ** If No Records Exists, then show 'No Data to Display' Message
      *
     C                   EVAL      SflDsp = False
     C                   EVAL      NoData = True
     C                   EVAL      PMsgId = 'ASM0001'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTLoadSFL - Load the subfile for Time Zone Level            *
      *                                                               *
      *  Called by: SRBldSfl, SRProcess, SRToggleReq                  *
      *                                                               *
      *  Calls: SRErrDta, SRRecFilter                                 *
      *                                                               *
      *****************************************************************
     C     SRTLoadSFL    BEGSR
      *
      ** Intialise Filter Flags - No Search Criteria
     C                   EVAL      WSelectYN = 'Y'
      *
      ** If Relative Record Number Of The Last Record Loaded In The
      ** Subfile Is Greater Than Zero
      *
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      RRN0 = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
     C                   ENDIF
      *
      ** If Position field - Time Zone Code is not blank,
      ** Set the Pointer To the Entered Time Zone Code
      *
     C                   IF        (H@TZCOD <> *BLANKS) AND
     C                             (Rollup = *OFF) AND
     C                             NOT %EOF(SDTIZOL0)
     C     H@TZCOD       SetLL     SDTIZOL0
     C                   ENDIF
 
     C                   IF        %EOF(SDTIZOL0)
     C     *LOVAL        SETLL     SDTIZOL0
     C                   ENDIF
      *
      ** Reset Counter
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
     C                   Dow       WCtr < SflPag And
     C                             Not %Eof(SDTIZOL1)
      *
      ** Read the Time Zone file
     C                   READ      SDTIZOL0
      *
     C                   IF        %EOF(SDTIZOL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        Not %Eof(SDTIZOL0)
 
     C                   EVAL      D@TZLCD  = *BLANKS
     C                   EVAL      D@TZCOD  = TZTZCD
     C                   EVAL      D@TZYR   = TZYEAR
     C                   EVAL      D@STDES  = TZSDSC
     C                   MOVEL     TZGMT         D@DTIME
     C                   EVAL      D@GMTS   = TZGMTS
     C                   EVAL      D@DSTCD  = TZDSTC
     C                   EVAL      D@ZONE1 = *BLANKS
      *
      ** Check for any filter
      *
     C                   EXSR      SRRecFilter
      *
      ** WRITE the Selected Records
      *
     C                   IF        WSelectYN = 'Y'
     C                   EVAL      RRN0 = RRN0 + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      D0OPT = *BLANKS
     C                   EVAL      ActnErr = False
     C                   WRITE     SDM01005S2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check For Last Record for Switching On the SFLEND Indicator
      *
     C                   IF        %EOF(SDTIZOL0)
     C                   EVAL      SflEnd = True
     C                   Else
     C                   EVAL      SflEnd = False
     C                   ENDIF
      *
      ** Check If Records are Written Into Subfile
      *
     C                   IF        WLstRrn <> 0
     C                   EVAL      SflDsp = True
     C                   Else
      *
      ** If No Records Exists, then show 'No Data to Display' Message
      *
     C                   EVAL      SflDsp = False
     C                   EVAL      NoData = True
     C                   EVAL      PMsgId = 'ASM0001'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrSfl - Process the Subfile Functions                      *
      *                                                               *
      *  Called by: SRProcess, SRToggleReq                            *
      *                                                               *
      *  Calls: SRErrDta, SRPopScrVal,SRValDetails, SRGetLocalTime,   *
      *         SRPopHistDS, SRProcAction                             *
      *                                                               *
      *****************************************************************
     C     SRPrSfl       BEGSR
      *
      ** Check For Last Relative Record Number
     C                   IF        WLstRrn > *ZEROS
      *
      ** Reset Error Flag
      *
     C                   READC     SDM01005S2
     C                   Dow       Not %Eof
      *
     C                   EVAL      WIdx = *ZEROS
      *
     C                   IF        (D0OPT <> *Blanks)
      *
      ** Invalid Action Code
      *
     C                   IF        (D0OPT <> Amend) AND
     C                             (D0OPT <> Enquire) AND
     C                             (D0OPT <> Delete) AND
     C                             (D0OPT <> Copy  ) AND                                    BUG19523
     C                             (PMode = 'M')
     C                   EVAL      PMsgId = 'USR9173'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   EVAL      ActnErr = True
      *
      ** Validation for Action code - in case of Enquire mode
      *
     C                   ELSEIF    (D0OPT <> Enquire) AND
     C                             (D0OPT <> *BLANKS) AND
     C                             (PMode = 'E')
 
     C                   EVAL      PMsgId = 'SDA0005'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
 
     C                   ENDIF
      *
      ** If User doesn't have required authority
      *
     C                   IF        WIdx > *ZEROS
     C                   EVAL      WError = 'Y'
     C                   EVAL      ActnErr = True
     C                   EVAL      D0SFRN = RRN0
     C                   Else
     C                   EVAL      ActnErr = False
     C                   EVAL      WError = 'N'
     C                   ENDIF
 
     C                   EVAL      *IN34 = True
     C                   UPDATE    SDM01005S2
      *
     C                   ENDIF
     C                   READC     SDM01005S2
      *
     C                   ENDDO
      *
     C                   EVAL      *IN34 = False
      *
      ** If Error, Stop Processing Further
      *
     C                   IF        ((WError = 'Y') OR
     C                             AddRecord = *ON)
     C                   LeaveSR
     C                   ENDIF
      *
     C                   READC     SDM01005S2
      *
     C                   Dow       Not %Eof
      *
      ** Call the Maintenance Program In Amend Mode
      *
     C                   IF        D0OPT <> *BLANKS
     C                   EVAL      Cancel = False
     C                   EVAL      POpt = D0OPT
 
     C                   IF        WCurrentLevel = 'T'
     C*****KSdtizol1A    CHAIN     SDTIZOL1                                                 BUG19141
     C     KSdtizol1A    CHAIN(N)  SDTIZOL1                                                 BUG19141
     C                   ELSE
     C*****KSdtzlvL0     CHAIN     SDTZLVL1                                                 BUG19141
     C     KSdtzlvL0     CHAIN(N)  SDTZLVL1                                                 BUG19141
     C                   ENDIF
     C
     C                   IF        %Found(SDTZLVL0) Or %Found(SDTIZOL1)
 
     C                   IF        WCurrentLevel = 'T'
     C                   EVAL      S1TZYR  =  TZYEAR
     C                   EVAL      S1TZCOD =  TZTZCD
     C                   ELSE
     C     KSdtizol1A    CHAIN(N)  SDTIZOL0
     C                   IF        NOT %FOUND(SDTIZOL0)
     C     D@TZCOD       CHAIN(N)  SDTIZOL0
     C                   ENDIF
     C                   EVAL      S1BRCH  =  TLBRCA
     C                   EVAL      S1ZONE  =  TLZONE
     C                   EVAL      S1TZYR  =  TLYEAR
     C                   EVAL      S1TZCOD =  TLTZCD
     C                   ENDIF
 
     C                   EXSR      SRPopScrVal
     C                   EXSR      SRValDetails
     C                   IF        Widx = 0                                                 BUG19523
     C                   EXSR      SRGetLocalTime
     C                   ENDIF                                                              BUG19523
 
     C                   IF        D0OPT = Amend or D0OPT = Delete
     C                   MOVE      SDTIZODS      SDTIZODS2
     C                   MOVE      SDTZLVDS      SavSDTZLV                                  BUG19780
     C                   EXSR      SRPopHistDS
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate action code selected
      *
     C                   EXSR      SRProcAction
      *
      ** When 'F3' is Pressed, Return to Main Menu
      *
     C                   IF        Exit = True
     C                   EVAL      Exit = True
     C                   Leave
     C                   ENDIF
 
     C                   EVAL      D0OPT = *BLANKS
 
     C                   UPDATE    SDM01005S2
 
     C                   ENDIF
     C                   READC     SDM01005S2
 
     C                   ENDDO
 
     C                   IF        Cancel = True And WCurrentLevel = 'T'
     C                   EVAL      Cancel = False
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by: SRChkAut, SRPrSfl, SRLoadSfl, SRChkAut, SRFldVal  *
      *             SRDelete, SRValDelete                             *
      *                                                               *
      *  Calls: ZA0350                                                *
      *                                                               *
      *****************************************************************
     C     SRErrDta      BEGSR
 
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      *BLANKS       PMsgData
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFldVal - Validate the Data of The Fields                   *
      *                                                               *
      *  Called by: SRInsert, SRCopyRecord                            *
      *                                                               *
      *  Calls: SRErrDta, SRValBranch                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRFldVal      Begsr
 
     C                   EVAL      WIDX = 0
     C                   CALL      'ZA0250'
     C   88              IF        S1BRCH = *Blanks
      *
      ** Branch Code is Blank
      *
     C                   EVAL      PMsgId = 'ASM0005'
     C                   EVAL      *IN56 = True
     C                   EVAL      Widx = WIdx + 1
     C                   EXSR      SRErrDta
 
     C                   Else
      *
      ** Check if valid branch code.
      *
     C                   EXSR      SRValBranch
 
     C                   ENDIF
     C                   IF        S1TZCOD = *Blanks
      *
      ** Process Message Subfile
      *
     C                   EVAL      PMsgId = 'SWF0022'
     C                   EVAL      *IN50 = True
     C                   EVAL      Widx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ElseIf    S1TZCOD <> *Blanks  And
     C                             AddRecord = True And WCurrentLevel='T'
     C                   EVAL      *IN84 = False                                            BUG19780
      *
     C     KTZoneYear    CHAIN(N)  SDTIZOL0
      *
     C                   IF        %Found(SDTIZOL0)
      *
     C                   EVAL      PMsgId = 'SWF0023'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN50 = True
     C                   EXSR      SRErrDta
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     BUG19780
      ** Validate if Invalid Character was used in Time Zone Code                           BUG19780
     C                   IF        WCurrentLevel='T' And S1TZCOD <> *Blanks                 BUG19780
     C                   Z-ADD     1             nCtr              2 0                      BUG19780
     C                   DOW       nCtr <= %Len(%Trim(S1TZCOD))                             BUG19780
     C                   IF        %SCAN(%Subst(S1TZCOD:nCtr:1):InvalidChar) > 0            BUG19780
     C                   EVAL      PMsgId = 'SWF0048'                                       BUG19780
     C                   EVAL      *In50 = True                                             BUG19780
     C                   EVAL      WIdx = WIdx + 1                                          BUG19780
     C                   EXSR      SRErrDta                                                 BUG19780
     C                   LEAVESR                                                            BUG19780
     C                   ENDIF                                                              BUG19780
     C                   EVAL      nCtr = nCtr + 1                                          BUG19780
     C                   ENDDO                                                              BUG19780
     C                   ENDIF                                                              BUG19780
      *
      ** Year must be a valid value between 1900 and 2100.
      *
     C                   IF        S1TZYR <> *BLANKS
     C                   MOVE      S1TZYR        nYear             4 0
     C                   IF        (nYear < 1900  OR nYear > 2100) OR
     C                              nYear = 0  OR %Len(%Trim(S1TZYR)) <> 4
     C                   EVAL      PMsgId = 'SWF0002'
     C                   EVAL      *In57 = True
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *                                                                                     BUG19780
      ** If year is entered, it must be Greater than or Equal to Current year.              BUG19780
     C                   ELSE                                                               BUG19780
     C                   IF        nYear <  nCurrYear                                       BUG19780
     C                   EVAL      PMsgId = 'SWF0049'                                       BUG19780
     C                   EVAL      *In57 = True                                             BUG19780
     C                   EVAL      WIdx = WIdx + 1                                          BUG19780
     C                   EXSR      SRErrDta                                                 BUG19780
     C                   ENDIF                                                              BUG19780
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG19400
      ** Validate Zone entered.                                                             BUG19400
      *                                                                                     BUG19400
     C                   IF        WCurrentLevel = 'Z'                                      BUG19400
     C                   EXSR      SRValZone                                                BUG19400
     C                   ELSE                                                               BUG20731
     C                   EVAL      S1ZONE = *BLANKS                                         BUG20731
     C                   ENDIF                                                              BUG19400
      *
      ** Must be a valid time zone for System and Branch Level.
      *
     C                   IF        WCurrentLevel <> 'T'
     C                   EXSR      SRValTimeZone                                            BUG19138
     C     KTZoneYear    CHAIN(N)  SDTIZOL0
     C                   IF        Not %Found(SDTIZOL0)
     C     *LOVAL        SETLL     SDTIZOL0
     C     S1TZCOD       CHAIN(N)  SDTIZOL0
     C                   IF        Not %Found(SDTIZOL0)
     C                   EVAL      PMsgId = 'SWF0032'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN50 = True
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
     C                   IF        %Found(SDTIZOL0)
     C                   IF        SaveTZCode = S1TZCOD
     C     KSBranch      CHAIN(N)  SDTZLVL0
     C                   ENDIF
     C                   EXSR      SRPopScrVal
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate details at Branch Level
      *
     C                   IF        WCurrentLevel <> 'T' And AddRecord = True
     C**********                   Or WCurrentLevel = 'S' And D0Opt = Amend        BUG20043 BUG21002
     C     KSdtzlvl1     CHAIN(N)  SDTZLVL0
     C                   IF        %Found(SDTZLVL0)
     C                   IF        WCurrentLevel = 'B'                                      BUG19141
     C                   EVAL      PMsgId = 'SWF0033'
     C                   ELSEIF    WCurrentLevel = 'Z'                                      BUG19400
     C                   EVAL      PMsgId = 'SWF0045'                                       BUG19400
     C                   ELSE                                                               BUG19141
     C                   EVAL      PMsgId = 'SWF0042'                                       BUG19141
     C                   ENDIF                                                              BUG19141
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN50 = True
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   EVAL      S1TZTZLC = WCurrentLevel
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Amend record Subroutine                            *
      *                                                               *
      *  Called by: SRSystemLevel, SRProcAction                       *
      *                                                               *
      *  Calls: SRReset, SRValDetails, SRPopTabVal, SRSytemLvlUpd     *
      *         SRUpdateHist,                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRAmend       BEGSR
 
     C                   Reset                   WSaveRecord                                BUG19361
     C                   SELECT
     C                   WHEN      WcurrentLevel = 'B'
     C                   EVAL      *In88 = True
     C                   WHEN      WcurrentLevel = 'S'
     C                   EVAL      *In86 = True
     C                   WHEN      WcurrentLevel = 'Z'
     C                   EVAL      *In83 = True
     C                   ENDSL
 
     C                   IF        WcurrentLevel <> 'T'
 
     C                   WRITE     SDM01005F0
     C                   DOW       Exit = False And Cancel = False
     C                   WRITE     SDM01005C1
     C                   Exfmt     SDM01005D6
      *
     C                   MOVE      TLTZCD        SaveTZCode       10
     C                   EXSR      SRFldVal
     C                   EXSR      SRValDetails
      *
     C                   IF        WIdx = 0
     C                   EVAL      D@TZLCD =  WCurrentLevel
     C**********         EVAL      D@TZCOD =  S1TZCOD                                       BUG19780
     C**********         EVAL      S1TZYR = TLYEAR                                          BUG19780
     C                   EVAL      D@TZCOD = sTLTZCD                                        BUG19780
     C                   EVAL      D@TZYR  = sTLYEAR                                        BUG19780
     C                   EVAL      D@ZONE  = sTLZONE                                        BUG19780
     C*****KSdtzlvL0     CHAIN     SDTZLVL1                                                 BUG19141
     C     KSdtzlvL0     CHAIN(N)  SDTZLVL1                                                 BUG19141
     C                   IF        NOT %FOUND(SDTZLVL1)
     C     *LOVAL        SETLL     SDTZLVL1
     C*****KSdtzlvL0A    CHAIN     SDTZLVL1                                                 BUG19141
     C     KSdtzlvL0A    CHAIN(N)  SDTZLVL1                                                 BUG19141
     C                   ENDIF
     C                   EVAL      S2ZONE  =  S1ZONE
     C                   EVAL      S2BRCH  =  S1BRCH
     C                   EVAL      S2TZYR  =  S1TZYR
     C                   EVAL      S2TZCOD =  S1TZCOD
     C                   LEAVE
     C                   ENDIF
     C
     C                   ENDDO
     C                   ENDIF
 
     C                   Dow       Exit = False And Cancel = False
 
     C                   WRITE     SDM01005F0
     C                   WRITE     SDM01005C1
 
     C                   SELECT
 
     C                   WHEN      WCurrentLevel = 'B' OR WCurrentLevel = 'Z' Or
     C                             WCurrentLevel = 'S'
     C                   EVAL      *In82 = True
     C                   EVAL      DDDES1 = DDDDES
     C                   EXFMT     SDM01005D3
     C                   EVAL      DDDDES  = DDDES1
     C                   Eval      *In82 = False
 
     C                   WHEN      WCurrentLevel = 'T'
     C                   Exfmt     SDM01005D2
     C                   EXSR      SRReset
     C                   EXSR      SRFldVal
     C                   EXSR      SRValDetails
 
     C                   ENDSL
 
     C                   IF        WIdx = 0  And KeyPressed = Cmd_Enter
      *
      * Populate Table fields
      *
     C                   Reset                   WSaveRecord                                BUG21226
     C                   EVAL      cUpdBrchFlag = 'N'                                       BUG21226
     C                   EVAL      RecUpdFlag = False
     C                   IF        SaveTZCode <> S2TZCOD  AND
     C                             SaveTZCode <> *Blanks
     C                   EVAL      RecUpdFlag = True
     C                   ENDIF
     C                   EXSR      SRPopTabVal
     C                   EVAL      TZRECI = 'D'
     C                   EVAL      TZLCHT = 'A'
     C                   MOVE      SDTIZODS      SDTIZODS3
      *
      ** Updateto Time Zone Code File only if transaction was accepted.
      *
     C                   IF        WSaveRecord = 'Y'
 
     C                   IF        WCurrentLevel = 'T'
     C                   EXSR      SRChkChange
     C                   MOVE      SDTIZODS3     SDTIZODS
 
     C                   IF        HistUpdFlag = True
     C                   EXSR      SRPopHistDS
     C                   EXSR      SRValHistRec
     C                   ENDIF
     C                   EVAL      D@TZCOD = NTZTZCD
     C                   EVAL      D@TZYR  = NTZYEAR
     C     KSdtizoL1A    CHAIN     SDTIZOL1
     C                   IF        %FOUND(SDTIZOL1)
     C                   MOVE      SDTIZODS3     SDTIZODS
     C                   UPDATE    SDTIZOD1
     C                   EXSR      SRTimeZoneUPD
     C                   ENDIF
 
     C                   ELSE
 
     C     KSdtzlvL0     CHAIN     SDTZLVL1                                                 BUG19141
     C                   IF        NOT %FOUND(SDTZLVL1)                                     BUG19141
     C     *LOVAL        SETLL     SDTZLVL1                                                 BUG19141
     C     KSdtzlvL0A    CHAIN     SDTZLVL1                                                 BUG19141
     C                   ENDIF                                                              BUG19141
     C                   EXSR      SRPopTabVal                                              BUG19141
     C                   EVAL      TLDESC  = DDDES1                                         BUG19141
     C                   UPDATE    RSDTZ_LVL1
     C                   MOVE      SDTZLVDS      TmpSDTZLV
 
     C                   IF        RecUpdFlag = True
     C**********         EXSR      SRCurrBrchUPD                                            BUG21226
     C                   EXSR      SRPopHistDS
     C                   EXSR      SRValHistRec
     C                   ENDIF
 
     C                   ENDIF
     C                   MOVE      TLBRCA        SaveBranch        3
      *
      ** Cascade changes based on Time zone level code
      *
     C                   IF        RecUpdFlag = True
     C                   EXSR      SRAppLevelChg
     C                   ENDIF
      *
      ** Update changes to related record
      *
     C                   IF        RecUpdFlag = True
     C                   EXSR      SRCurrBrchUPD                                            BUG21226
     C                   EXSR      SRBrchRecUpd
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                     BUG21226
      ** Update database records.                                                           BUG21226
      *                                                                                     BUG21226
     C                   EXSR      SRUpdRecords                                             BUG21226
 
     C                   IF        WSaveRecord = 'N' And Cancel = True And                  BUG21226
     C                             cUpdBrchFlag = 'N'                                       BUG21226
     C                   EVAL      Cancel = False                                           BUG21226
     C                   ELSE                                                               BUG21226
     C                   EVAL      Cancel = True
     C                   ENDIF                                                              BUG21226
      *
     C                   ENDIF
      *
     C                   ENDDO
 
     C                   IF        Exit = True
     C                   EVAL      EndPGMFlag = True
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete - Delete the Selected Record                        *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRValDelete                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
     C                   EXSR      SRValDelete
 
     C                   EVAL      *IN75 = True                                             BUG19910
     C                   EVAL      *IN76 = False                                            BUG20043
     C                   IF        Widx = 0
      ** Clear Program Message Queue
     C                   CALL      'ZA0250'
     C**********         EVAL      PMsgId = 'USR0534'                                       BUG19141
     C**********         EVAL      PMsgId = 'USR0536'                              BUG19141 BUG19950
     C                   EVAL      PMsgId = 'USR0537'                                       BUG19950
     C                   EVAL      *IN76 = True                                             BUG20043
     C                   ELSE
     C**********         EVAL      *IN89 = False                                            BUG20043
     C                   ENDIF
     C                   EXSR      SRErrDta
     C                   Dow       Cancel = False AND Exit = False
     C                   WRITE     SDM01005F0
     C                   WRITE     SDM01005C1
     C                   Exfmt     SDM01005D3
 
     C                   IF        DltRecord = True  And Widx = 0
      *                                                                                     BUG19141
     C                   CALLB     'ZAGENTMSTM'                                             BUG19141
     C                   PARM                    TimeStamp                                  BUG19141
      *                                                                                     BUG19141
     C                   EVAL      TZTMST = TimeStamp                                       BUG19141
     C                   EVAL      TLTMST = TimeStamp                                       BUG19141
      *
      ** mark record as deleted '*'
      *
     C                   IF        WCurrentLevel = 'T'                                      BUG19141
     C     KSdtizoL1A    CHAIN     SDTIZOL1                                                 BUG19141
     C                   IF        %FOUND(SDTIZOL1)                                         BUG19141
     C                   EVAL      TZRECI = '*'
     C                   EVAL      TZLCHT = 'D'
     C                   UPDATE    SDTIZOD1
     C                   EVAL      Cancel = True                                            BUG19141
     C                   ENDIF                                                              BUG19141
     C                   ELSE                                                               BUG19141
     C     KSdtzlvL0     CHAIN     SDTZLVL1                                                 BUG19141
     C                   IF        %FOUND(SDTZLVL1)                                         BUG19141
     C                   EVAL      TLRECI = '*'                                             BUG19141
     C                   EVAL      TLCHTP = 'D'                                             BUG19141
     C                   UPDATE    RSDTZ_LVL1                                               BUG19141
     C                   EVAL      Cancel = True                                            BUG19141
     C                   ENDIF                                                              BUG19141
      *                                                                                     BUG19141
     C                   ENDIF                                                              BUG19141
     C**********         EVAL      Cancel = True                                            BUG19141
      *                                                                                     BUG21226
      ** Update database records.                                                           BUG21226
      *                                                                                     BUG21226
     C                   EXSR      SRUpdRecords                                             BUG21226
 
     C                   ENDIF
     C                   ENDDO
 
      ** Clear Program Message Queue
     C                   CALL      'ZA0250'
      *
     C                   EVAL      *IN75 = False                                            BUG19910
     C                   EVAL      *IN76 = False                                            BUG20043
     C                   EVAL      *IN89 = WSavModeInd
     C                   IF        Exit = True
     C                   EVAL      EndPGMFlag = True
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDelete - Validate if record selected has no linkages.   *
      *                                                               *
      *  Called by: SRDelete                                          *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRValDelete   BEGSR
      *
      ** Execute branch validation only on Branch Level transaction.
      *
      ** Allow deletion of record on Branch Level transaction.                              BUG21005
     C**********         IF        *IN88 = True                                             BUG21005
     C**********         EVAL      S1BRCH = TVBRCA                                          BUG21005
     C**********         EXSR      SRValBranch                                              BUG21005
     C**********         IF        PRtcd  =  *Blanks                                        BUG21005
     C**********         EVAL      PMsgId = 'SWF0034'                                       BUG21005
     C**********         EVAL      Widx = WIdx + 1                                          BUG21005
     C**********         EXSR      SRErrDta                                                 BUG21005
     C**********         ELSE                                                               BUG21005
     C**********         EVAL      Widx =  0                                                BUG21005
     C**********         ENDIF                                                              BUG21005
     C**********         ENDIF                                                              BUG21005
      *                                                                                     BUG21004
     C     *LOVAL        SETLL     SDTZLVL0                                                BUG21004A
     C                   READ      SDTZLVL0                                                BUG21004A
     C                   DOW       NOT %EOF(SDTZLVL0)                                      BUG21004A
     C                   IF        (TLYEAR = cCurrYear OR TLYEAR = *BLANKS) AND            BUG21004A
     C                             TLTZLC = 'S'                                            BUG21004A
     C                   ADD       1             #TZCTR           10 0                     BUG21004A
     C                   ENDIF                                                             BUG21004A
     C                   READ      SDTZLVL0                                                BUG21004A
     C                   ENDDO                                                             BUG21004A
      *                                                                                    BUG21004A
     C                   IF        *IN86 = True AND                                        BUG21004A
     C                             #TZCTR = 1  AND                                         BUG21004A
     C                             (TZYEAR = cCurrYear OR TZYEAR = *BLANKS)                BUG21004A
     C                   EVAL      PMsgId = 'SWF0055'                                       BUG21004
     C                   EVAL      Widx = WIdx + 1                                          BUG21004
     C                   EXSR      SRErrDta                                                 BUG21004
     C                   ENDIF                                                              BUG21004
     C                   EVAL      #TZCTR = 0                                              BUG21004A
      *
      ** Validate if time zone is already used either on Branch or System level.
      *
     C                   IF        WCurrentLevel = 'T'
     C                   EVAL      S1TZCOD = D@TZCOD
     C                   EVAL      S1TZYR  = D@TZYR
     C     *Loval        SETLL     SDTZLVL5
     C     KTZoneYear    CHAIN(N)  SDTZLVL5
     C                   IF        %FOUND(SDTZLVL5)
     C                   EVAL      PMsgId = 'SWF0035'
     C                   EVAL      Widx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *                                                                                     BUG19523
      ** Validate if time Zone code is already used in Market Identification File           BUG19523
      *                                                                                     BUG19523
     C     *LOVAL        SETLL     SDMICCL1                                                 BUG19523
     C     S1TZCOD       CHAIN(N)  SDMICCL1                                                 BUG19523
     C                   IF        %Found(SDMICCL1)                                         BUG19523
     C                   EVAL      PMsgId = 'SWF0047'                                       BUG19523
     C                   EVAL      Widx = WIdx + 1                                          BUG19523
     C                   EXSR      SRErrDta                                                 BUG19523
     C                   ENDIF                                                              BUG19523
 
     C                   ENDIF
     C
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert: Insert a new record in the file                    *
      *                                                               *
      *  Called by: SRProcess, SRToggleReq , SRSystemLevel            *
      *                                                               *
      *  Calls: SRReset, SRFldVal, SRPopScrVal, SRInsertLevel         *
      *                                                               *
      *****************************************************************
      *
     C     SRInsert      BEGSR
      *
     C                   Reset                   SDM01005D1
     C                   Reset                   WSaveRecord                                BUG19361
 
     C**********         EVAL      S1ZONE  = *Blanks                                        BUG20731
     C                   EVAL      S1ZONE  = ZoneName                                       BUG20731
     C                   EVAL      S1TZCOD = *Blanks
     C                   EVAL      S1TZYR  = *Blanks
     C                   EVAL      S1BRCH  = *Blanks
     C                   MOVE      *BLANKS       DDCRTM                                     BUG19243
     C                   EVAL      S2OFFSET = *Blanks                                       BUG19243
     C                   EVAL      DDDSDH = *Zeros                                          BUG20043
     C                   EVAL      DDDENH = *Zeros                                          BUG20043
     C                   EVAL      *IN85  = *Off                                            BUG20043
     C                   Clear                   SDTIZODS
     C                   EXSR      SRPopScrVal
 
     C                   EXSR      SRReset
     C                   EVAL      *IN89 = True
     C                   EVAL      *IN65 = False                                            BUG19780
     C                   SELECT
     C                   WHEN      WcurrentLevel = 'B'
     C                   EVAL      *In88 = True
     C                   WHEN      WcurrentLevel = 'S'
     C                   EVAL      *In86 = True
     C                   WHEN      WcurrentLevel = 'Z'
     C                   EVAL      *In83 = True
     C                   ENDSL
     C                   WRITE     SDM01005F0
 
     C                   Dow       Exit = False And Cancel = False
 
     C                   Reset                   WSaveRecord                                BUG21226
     C                   WRITE     SDM01005C1
     C                   Exfmt     SDM01005D1
      *
     C                   IF        Refresh = True
     C                   EXSR      SRReset
     C                   EVAL      S1TZCOD = *BLANKS
     C**********         EVAL      S1ZONE  = *BLANKS                                        BUG20731
     C                   EVAL      S1ZONE  = ZoneName                                       BUG20731
     C                   EVAL      S1TZYR  = *BLANKS
     C                   EVAL      S1BRCH  = *BLANKS
     C                   ITER
     C                   ENDIF
      *                                                                                     BUG21226
     C                   IF        Exit = True Or Cancel = True                             BUG21226
     C                   LEAVE                                                              BUG21226
     C                   ENDIF                                                              BUG21226
      *
     C                   EXSR      SRFldVal
      *                                                                                     BUG20043
      ** Redisplay Screen so that user has an option to input year.                         BUG20043
     C                   IF        Widx = 0 And S1TZCOD <> *Blanks And                      BUG20043
     C                             WcurrentLevel <> 'T'                                     BUG20043
     C                             And S1TZYR = *Blanks                                     BUG20043
     C                   EVAL      *IN56 = False                                            BUG20043
     C                   CALL      'ZA0250'                                                 BUG20043
     C                   WRITE     SDM01005C1                                               BUG20043
     C                   Exfmt     SDM01005D1                                               BUG20043
     C                   EXSR      SRFldVal                                                 BUG20043
     C                   ENDIF                                                              BUG20043
      *
     C**********         IF        WIdx = 0                                                 BUG21226
     C                   IF        WIdx = 0 And Cancel = False                              BUG21226
      *
     C                   CALL      'ZA0250'
     C                   IF        WCurrentLevel = 'T'
     C     KSdtizoL1     CHAIN(N)  SDTIZOL0
     C                   ELSE
     C     KSdtzlvl1     CHAIN(N)  SDTZLVL0
     C                   ENDIF
      *
     C                   IF        Not %Found(SDTIZOL0) Or Not %Found(SDTZLVL0)
     C                   EVAL      S2TZCOD = S1TZCOD
     C                   EVAL      S2ZONE  = S1ZONE
     C                   EVAL      S2TZYR  = S1TZYR
     C                   EVAL      S2BRCH  = S1BRCH
 
     C                   IF        Exit <> True Or Cancel <> True                           BUG21001
     C                   EXSR      SRInsertLevel
     C                   IF        Cancel = True  AND                                       BUG21001
     C                             SaveKey = 'N'                                            BUG21001
     C                   EVAL      Cancel = False                                           BUG21001
     C                   EXSR      SRReset                                                  BUG21001
     C                   ENDIF                                                              BUG21001
     C                   ENDIF                                                              BUG21001
 
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *IN89 = WSavModeInd
     C                   IF        Cancel = True
     C                   EVAL      Cancel = False
     C                   ENDIF
     C                   IF        Exit = True
     C                   EVAL      EndPGMFlag = True
     C                   ENDIF
      *
      ** Clear Program Queue And Message File
      *
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsertLevel   - Validate Level code during Insert          *
      *                                                               *
      *  Called by: SRInsert, SRCopyRecord                            *
      *                                                               *
      *  Calls: SRReset, SRValDetails, SRPopScrVal, SRPopTabVal,      *
      *         SRSytemLvlUpd,                                        *
      *                                                               *
      *****************************************************************
     C     SRInsertLevel Begsr
      *
      ** Display Screen Details for Insert.
      *
     C                   Dow       Exit = False And Cancel = False
 
     C                   MOVE      'N'           SaveKey           1                        BUG21001
     C                   WRITE     SDM01005F0
     C                   WRITE     SDM01005C1
 
     C                   IF        WCurrentLevel = 'T'
     C                   EXFMT     SDM01005D2
      *                                                                                     BUG19136
     C                   If        DDGMTS = *Blanks                                         BUG19136
     C                   Eval      DDGMTS = '+'                                             BUG19136
     C                   EndIf                                                              BUG19136
      *                                                                                     BUG19136
     C                   EXSR      SRReset
     C                   EXSR      SRValDetails
     C                   EVAL      TZRECI = 'D'
     C                   EVAL      TZLCHT = 'I'
     C                   Else
     C
     C                   IF        %FOUND(SDTIZOL0)
     C                   EXSR      SRPopScrVal
     C                   EXSR      SRValDetails
     C                   EVAL      S2ZONE = S1ZONE
     C                   EVAL      S2BRCH = S1BRCH
     C                   EVAL      *In82 = True
     C                   EVAL      DDDES1 = DDDDES
     C                   EXFMT     SDM01005D3
     C                   EVAL      DDDDES  = DDDES1
     C                   Eval      *In82 = False
     C                   EVAL      TLRECI = 'D'
     C                   EVAL      TLCHTP = 'I'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Initialize screen fields if F5 was pressed.
      *
     C                   IF        Refresh = True
     C                   EXSR      SRReset
     C                   EXSR      SRInitScrVal
     C                   EVAL      Refresh = False
     C                   ITER
     C                   ENDIF
 
     C                   IF        WIdx = 0 And KeyPressed = Cmd_Enter
     C                   MOVE      'Y'           SaveKey                                    BUG21001
     C                   Reset                   WSaveRecord                                BUG21226
     C                   EVAL      cUpdBrchFlag = 'N'                                       BUG21226
      *                                                                                     BUG20043
      ** Display confirmation screen before saving record.                                  BUG20043
      *                                                                                     BUG20043
     C                   IF        WCurrentLevel = 'T'                                      BUG20043
     C                   CALL      'ZA0250'                                                 BUG20043
     C                   WRITE     SDM01005C1                                               BUG20043
     C                   WRITE     SDM01005F3                                               BUG20043
     C                   EXFMT     SDM01005D3                                               BUG20043
     C                   IF        KeyPressed <> Cmd_Enter                                  BUG20043
     C                   EVAL      WSaveRecord = 'N'                                        BUG20043
     C                   ENDIF                                                              BUG20043
     C                   ENDIF                                                              BUG20043
      *                                                                                     BUG21001
     C                   IF        Cancel = True                                            BUG21001
     C                   EVAL      Cancel = False                                           BUG21001
     C                   Reset                   WSaveRecord                                BUG21001
     C                   MOVE      'N'           SaveKey           1                        BUG21001
     C                   ELSE                                                               BUG21001
      *
      ** Populate Table Field based on screen fields
      *
     C                   EXSR      SRPopTabVal
     C                   MOVE      SDTIZODS      SDTIZODS3
     C                   MOVE      SDTZLVDS      TmpSDTZLV
      *
      ** WRITE to Time Zone Code File only if transaction was accepted.
      *
     C                   IF        WSaveRecord = 'Y'
 
     C                   IF        WCurrentLevel = 'T'
     C                   MOVE      SDTIZODS3     SDTIZODS
     C                   WRITE     SDTIZOD1
     C                   ELSE
     C                   MOVE      SDTZLVDS      TmpSDTZLV
     C                   WRITE     RSDTZ_LVL1
     C**********         IF        WCurrentLevel = 'B'                                      BUG21226
     C**********         EXSR      SRCurrBrchUPD                                            BUG21226
     C**********         ENDIF                                                              BUG21226
 
     C                   ENDIF
      *
      ** Cascade changes based on Time zone level code
      *
     C                   EXSR      SRAppLevelChg
      *                                                                                    BUG21226
     C                   IF        WCurrentLevel = 'B'                                     BUG21226
     C                   EXSR      SRCurrBrchUPD                                           BUG21226
     C                   ENDIF                                                             BUG21226
      *
      ** Write record to History File.
      *
     C                   EXSR      SRPopHistDS
     C                   EXSR      SRValHistRec
      *                                                                                     BUG19361
      ** Update branch Level Record Update                                                  BUG19361
      *                                                                                     BUG19361
     C                   EXSR      SRBrchRecUpd                                             BUG19361
      *                                                                                     BUG21226
      ** Update database records.                                                           BUG21226
      *                                                                                     BUG21226
     C                   EXSR      SRUpdRecords                                             BUG21226
      *                                                                                     BUG21226
     C                   IF        WSaveRecord = 'N' And Cancel = True And                  BUG21226
     C                             cUpdBrchFlag = 'N'                                       BUG21226
     C                   MOVE      'Y'           SaveKey                                    BUG21226
     C                   EVAL      Cancel = False                                           BUG21226
     C                   ITER                                                               BUG21226
     C                   ENDIF                                                              BUG21226
 
     C                   ENDIF
      *
      ** Build the Subfile Along With the New Records Added
      *
     C                   EVAL      Cancel = True
 
     C                   ENDIF
     C                   ENDIF                                                              BUG21001
 
     C                   ENDDO
 
     C                   EVAL      *IN65 = False                                            BUG19780
     C                   IF        Exit = True
     C                   EVAL      EndPGMFlag = True
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAppLevelChg  - Apply changes based on Time zone level      *
      *                                                               *
      *  Called by: SRAmend, SRInsert                                 *
      *                                                               *
      *  Calls: SRSytemLvlUpd, SRBrchLvlUpd                           *
      *                                                               *
      *****************************************************************
      *
     C     SRAppLevelChg BEGSR
 
     C                   SELECT
 
     C                   WHEN      WCurrentLevel = 'S' OR
     C                             WCurrentLevel = 'Z'
 
     C                   EVAL      ConfirmUpdate = False
     C                   Dow       Exit = False And Cancel = False
 
     C                   WRITE     SDM01005F2
     C                   Exfmt     SDM01005D5
 
     C                   IF        (ConfirmUpdate = True  AND
     C                              WCurrentLevel = 'Z')  OR
     C                             (WCurrentLevel = 'S'   AND
     C                              KeyPressed    = Cmd_Enter)
      *
      ** Update branch file if year entered is less than or equal to current year
      *
     C                   IF        S2TZYR <> *BLANKS
     C                   IF        %DEC(S2TZYR:4:0) <= nCurrYear
     C                   EXSR      SRSytemLvlUpd
     C                   ENDIF
     C                   ELSE
     C                   EXSR      SRSytemLvlUpd
     C                   ENDIF
     C                   EVAL      Cancel = True
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        ConfirmUpdate = False
     C                             AND KeyPressed <> Cmd_Enter
     C                   EVAL      WSaveRecord = 'N'
     C                   ENDIF
 
     C                   IF        Exit = True
     C                   EVAL      EndPGMFlag = True
     C                   ENDIF
 
     C                   WHEN      WCurrentLevel = 'B'
     C                   EXSR      SRBrchLvlUpd
 
     C                   ENDSL
 
     C                   IF        Exit = True
     C                   EVAL      EndPGMFlag = True
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSytemLvlUpd - Handle System Level record update            *
      *                                                               *
      *  Called by: SRAmend                                           *
      *                                                               *
      *  Calls: SRChkDSTOffSet                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRSytemLvlUpd BegSR
      *
      ** Get current DST offset
      *
     C**********         EXSR      SRChkDSTOffSet                                           BUG19624
     C                   EVAL      wChgtype = WCurrentLevel
      *
      ** Update branch offset if Zone level otherwise update system offset
      *
     C******Loval        Setll     SDBRCHL0                                                 MD035941
     C**********         READ      SDBRCHL0                                                 MD035941
     C**********         Dow       Not %Eof(SDBRCHL0)                                       MD035941
     C     *Loval        Setll     SDBRCHLZ                                                 MD035941
     C                   READ      SDBRCHLZ                                                 MD035941
     C                   Dow       Not %Eof(SDBRCHLZ)                                       MD035941
     C                   IF        WCurrentLevel = 'Z'
     C                   EVAL      A8TMOF = NewEffOffset
     C                   EVAL      A8SIGN = GMTSign
     C                   ELSE
     C                   EVAL      A8STOF = NewEffOffset
     C                   EVAL      A8SSIN = GMTSign
     C                   ENDIF
     C                   EVAL      A8TYLC  = 'A'                                            BUG19910
     C                   EVAL      A8LCD   = BJRDNB                                         BUG19910
     C                   UPDATE    @A8REB1
     C                   EXSR      SRUpdBrchLog                                             BUG19910
     C**********         READ      SDBRCHL0                                                 MD035941
     C                   READ      SDBRCHLZ                                                 MD035941
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBrchLvlUpd - Handle Branch Level record UPDATE             *
      *                                                               *
      *  Called by: SRProcAction                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRBrchLvlUpd  BegSR
 
      *
      ** Get Current DST Offset
      *
     C**********         EXSR      SRChkDSTOffSet                                           BUG19624
     C                   EVAL      wChgtype = WCurrentLevel
 
     C                   Dow       Exit = False And Cancel = False
 
     C                   WRITE     SDM01005F2
     C                   Exfmt     SDM01005D3
      *
     ** Dont update branch if Year is greater than current year
      *
     C                   IF        S2TZYR <> *BLANKS
     C                   IF        (%Dec(S2TZYR:4:0) > nCurrYear) AND
     C                             (AllBrchUPDATE = True  OR
     C                              LocBrchUPDATE = True)
     C                   EVAL      Cancel = True
     C                   LEAVE
     C
     C                   ENDIF
     C                   ENDIF
     C                   IF        KeyPressed = Cmd_Enter                                   BUG19950
     C                   EVAL      Cancel = True                                            BUG19950
     C                   MOVE      'Y'           cUpdBrchFlag      1                        BUG21226
     C                   ELSE                                                               BUG21226
     C                   MOVE      'N'           cUpdBrchFlag                               BUG21226
     C                   ENDIF                                                              BUG19950
 
     C******LOVAL        SETLL     SDBRCHL0                                        BUG19361 MD035941
     C     *LOVAL        SETLL     SDBRCHLZ                                                 MD035941
     C                   Select
 
     C                   When      AllBrchUPDATE = True
     C**********         READ      SDBRCHL0                                                 MD035941
     C**********         Dow       Not %Eof(SDBRCHL0)                                       MD035941
     C                   READ      SDBRCHLZ                                                 MD035941
     C                   Dow       Not %Eof(SDBRCHLZ)                                       MD035941
 
     C                   IF        A8BRCD <> SaveBranch
     C                   EVAL      D@BRCA = A8BRCD
     C                   EXSR      SRChkLevelRec
     C                   EVAL      A8TMOF = NewEffOffset
     C                   EVAL      A8SIGN = GMTSign
     C                   EVAL      A8TYLC  = 'A'                                            BUG19910
     C                   EVAL      A8LCD   = BJRDNB                                         BUG19910
     C**********         UPDATE    @A8REB1                                                  BUG21071
     C**********         IF        Addrecord = True                                         BUG21071
      *                                                                                     BUG20043
      ** Create branch level records based on branch file.                                  BUG20043
     C                   EVAL      D@TZLCD = WcurrentLevel                                  BUG20043
     C                   EVAL      D@BRCA  = A8BRCD                                         BUG20043
     C     KSdtzlvl3A    CHAIN     SDTZLVL3                                                 BUG20043
     C                   IF        Not %Found(SDTZLVL3)                                     BUG20043
     C                   MOVE      TmpSDTZLV     SDTZLVDS
     C                   EVAL      TLBRCA = A8BRCD
     C                   EVAL      A8SSIN = cCurrSysSign                                    BUG21071
     C                   EVAL      A8STOF = nCurrSysOffs                                    BUG21071
     C                   WRITE     RSDTZ_LVL1
     C                   EXSR      SRPopHistDS
     C                   EXSR      SRValHistRec
     C                   ENDIF                                                              BUG20043
     C                   UPDATE    @A8REB1                                                  BUG21071
     C                   EXSR      SRUpdBrchLog                                             BUG21071
     C**********         ENDIF                                                              BUG21071
     C                   ENDIF
     C**********         READ      SDBRCHL0                                                 MD035941
     C                   READ      SDBRCHLZ                                                 MD035941
     C                   ENDDO
     C                   EVAL      Cancel = True
 
     C                   When      LocBrchUPDATE = True
     C**********         READ      SDBRCHL0                                                 MD035941
     C**********         DOW       Not %Eof(SDBRCHL0)                                       MD035941
     C                   READ      SDBRCHLZ                                                 MD035941
     C                   DOW       Not %Eof(SDBRCHLZ)                                       MD035941
     C                   IF        WLocCode = A8LCCD
     C                   EVAL      A8TMOF = NewEffOffset
     C                   EVAL      A8SIGN = GMTSign
     C                   EVAL      A8TYLC  = 'A'                                            BUG19910
     C                   EVAL      A8LCD   = BJRDNB                                         BUG19910
      *                                                                                     BUG21071
      ** Create branch level records based on branch file.                                  BUG21071
     C                   EVAL      D@TZLCD = WcurrentLevel                                  BUG21071
     C                   EVAL      D@BRCA  = A8BRCD                                         BUG21071
     C     KSdtzlvl3A    CHAIN     SDTZLVL3                                                 BUG21071
     C                   IF        Not %Found(SDTZLVL3)                                     BUG21071
     C                   MOVE      TmpSDTZLV     SDTZLVDS                                   BUG21071
     C                   EVAL      TLBRCA = A8BRCD                                          BUG21071
     C                   EVAL      A8SSIN = cCurrSysSign                                    BUG21072
     C                   EVAL      A8STOF = nCurrSysOffs                                    BUG21072
     C                   WRITE     RSDTZ_LVL1                                               BUG21071
     C                   EXSR      SRPopHistDS                                              BUG21071
     C                   EXSR      SRValHistRec                                             BUG21071
     C                   ENDIF                                                              BUG21071
     C                   UPDATE    @A8REB1
     C                   EXSR      SRUpdBrchLog                                             BUG19910
     C                   ENDIF
     C**********         READ      SDBRCHL0                                                 MD035941
     C                   READ      SDBRCHLZ                                                 MD035941
     C                   ENDDO
     C                   EVAL      Cancel = True
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   IF        LocBrchUPDATE = False And
     C                             AllBrchUPDATE = False
     C                   EVAL      WSaveRecord = 'N'
     C                   ENDIF
 
     C                   IF        Exit = True
     C                   EVAL      EndPGMFlag = True
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCurrBrchUPD - Update Current branch details                 *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCurrBrchUPD BEGSR
 
     C*****S2BRCH        CHAIN     SDBRCHL0                                                 MD035941
     C**********         IF        %Found(SDBRCHL0)                                         MD035941
     C     S2BRCH        CHAIN     SDBRCHLZ                                                 MD035941
     C                   IF        %Found(SDBRCHLZ)                                         MD035941
     C                   EVAL      A8TMOF = NewEffOffset
     C                   EVAL      A8SIGN = GMTSign
     C                   EVAL      A8TYLC  = 'A'                                            BUG19910
     C                   EVAL      A8LCD   = BJRDNB                                         BUG19910
     C                   EVAL      A8SSIN = cCurrSysSign                                    BUG21071
     C                   EVAL      A8STOF = nCurrSysOffs                                    BUG21071
     C                   UPDATE    @A8REB1
     C                   EXSR      SRUpdBrchLog                                             BUG19910
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTimeZoneUPD - Update details related to amended timezone   *
      *                                                               *
      *  Called by:  SRAmend                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRTimeZoneUPD BEGSR
 
     C     *Loval        SETLL     SDTZLVL5
     C     NTZTZCD       SETLL     SDTZLVL5
     C     NTZTZCD       READE(N)  SDTZLVL5
     C                   DOW       NOT %EOF(SDTZLVL5)
 
     C                   IF        TLYEAR = *BLANKS OR
     C                             TLYEAR = cCurrYear
     C                   IF        TLTZLC = 'S'
     C                   EXSR      SRSytemLvlUpd
     C                   ELSE
     C******LOVAL        SETLL     SDBRCHL0                                                 MD035941
     C*****TLBRCA        CHAIN     SDBRCHL0                                                 MD035941
     C     *LOVAL        SETLL     SDBRCHLZ                                                 MD035941
     C     TLBRCA        CHAIN     SDBRCHLZ                                                 MD035941
 
     C**********         IF        %FOUND(SDBRCHL0)                                         MD035941
     C                   IF        %FOUND(SDBRCHLZ)                                         MD035941
     C                   EVAL      A8TMOF = NewEffOffset
     C                   EVAL      A8SIGN = GMTSign
     C                   EVAL      A8TYLC  = 'A'                                            BUG19910
     C                   EVAL      A8LCD   = BJRDNB                                         BUG19910
     C                   UPDATE    @A8REB1
     C                   EXSR      SRUpdBrchLog                                             BUG19910
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     NTZTZCD       READE(N)  SDTZLVL5
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBrchRecUpd - Update branch record details                  *
      *                                                               *
      *  Called by: SRBrchLvlUpd                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRBrchRecUpd  BEGSR
 
     C                   EVAL      wChgType = WCurrentLevel
     C******LOVAL        SETLL     SDBRCHL0                                                 MD035941
     C**********         READ(N)   SDBRCHL0                                                 MD035941
     C     *LOVAL        SETLL     SDBRCHLZ                                                 MD035941
     C                   READ(N)   SDBRCHLZ                                                 MD035941
     C                   IF        AllBrchUpdate = True
     C**********         DOW       Not %Eof(SDBRCHL0)                                       MD035941
     C                   DOW       Not %Eof(SDBRCHLZ)                                       MD035941
 
     C                   IF        A8BRCD <> SaveBranch
     C                   EVAL      D@TZLCD  = WCurrentLevel
     C                   EVAL      D@BRCA   = A8BRCD
     C                   EVAL      D@TZYR   = nTZYEAR
     C     KSdtzlvl3     CHAIN     SDTZLVL3
     C                   IF        Not %Found(SDTZLVL3)                                     BUG19780
     C                   EVAL      D@TZYR   = *Blanks                                       BUG19780
     C     KSdtzlvl3     CHAIN     SDTZLVL3                                                 BUG19780
     C                   IF        Not %Found(SDTZLVL3)                                     BUG19780
     C     KSdtzlvl3A    CHAIN     SDTZLVL3                                                 BUG19780
     C                   ENDIF                                                              BUG19780
     C                   ENDIF                                                              BUG19780
     C                   IF        %Found(SDTZLVL3)
     C                   MOVE      TmpSDTZLV     SDTZLVDS
     C                   EVAL      TLBRCA = A8BRCD
     C                   EXSR      SRPopHistDS
     C                   EVAL      D@TZCOD  = LTLTZCD
     C                   EVAL      D@TZYR   = LTLYEAR
     C                   EXSR      SRValHistRec
     C                   UPDATE    RSDTZ_LVL3
     C                   IF        TLTZLC = 'S'
     C                   MOVE      'Y'           cSysFlag          1
     C                   EXSR      SRSytemLvlUpd
     C                   MOVE      'N'           cSysFlag
     C                   ELSE
     C                   MOVE      'N'           cSysFlag
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C**********         READ(N)   SDBRCHL0                                                 MD035941
     C                   READ(N)   SDBRCHLZ                                                 MD035941
     C                   ENDDO
     C                   ENDIF
 
     C                   IF        LocBrchUpdate = True
 
     C**********         DOW       Not %Eof(SDBRCHL0)                                       MD035941
     C                   DOW       Not %Eof(SDBRCHLZ)                                       MD035941
 
     C                   IF        A8BRCD <> SaveBranch AND
     C                             WLocCode = A8LCCD
     C                   EVAL      D@TZLCD  = WCurrentLevel
     C                   EVAL      D@BRCA   = A8BRCD
     C                   EVAL      D@TZYR   = nTZYEAR
     C     KSdtzlvl3     CHAIN     SDTZLVL3
     C                   IF        Not %Found(SDTZLVL3)                                     BUG19780
     C                   EVAL      D@TZYR   = *Blanks                                       BUG19780
     C     KSdtzlvl3     CHAIN     SDTZLVL3                                                 BUG19780
     C                   IF        Not %Found(SDTZLVL3)                                     BUG19780
     C     KSdtzlvl3A    CHAIN     SDTZLVL3                                                 BUG19780
     C                   ENDIF                                                              BUG19780
     C                   ENDIF                                                              BUG19780
     C                   IF        %Found(SDTZLVL3)
     C                   MOVE      TmpSDTZLV     SDTZLVDS
     C                   EVAL      TLBRCA = A8BRCD
     C                   EXSR      SRPopHistDS
     C                   EXSR      SRValHistRec
     C                   UPDATE    RSDTZ_LVL3
     C                   ENDIF
     C                   ENDIF
     C**********         READ(N)   SDBRCHL0                                                 MD035941
     C                   READ(N)   SDBRCHLZ                                                 MD035941
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkChange  - Check changes made at time zone details       *
      *                                                               *
      *  Called by: SRProcAction                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRChkChange   BEGSR
      *
      ** Identify type of change made
      *
     C                   EVAL      HistUpdFlag = True
     C                   SELECT
     C                   WHEN      HTHDSTC <> TZDSTC
     C                   EVAL      wTZDSTC =  HTHDSTC
     C                   EVAL      hTHTYLC  =  DSTCodeChg
     C                   WHEN      hTHDSTF <> TZDSTF
     C                   EVAL      hTHTYLC  = DSTFlagChg
     C                   EVAL      wTZDSTF =  TZDSTF
     C                   WHEN      hTHGMTS <> TZGMTS  OR hTHGMTO <> TZGMT
     C                   EVAL      hTHTYLC  = GMTDTSChg
     C                   EVAL      wTZGMTS =  TZGMTS
     C                   EVAL      wTZGMT  =  TZGMT
     C                   OTHER
     C                   EVAL      HistUpdFlag = False
     C                   ENDSL
     C                   EVAL      wChgType = hTHTYLC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkLevelRec - Check record if exist on current year        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRChkLevelRec BEGSR
 
     C                   IF        S2TZYR <> *BLANKS
     C                   MOVE      *ZEROS        nS2Year           4 0
     C                   EVAL      nS2Year = %DEC(S2TZYR:4:0)
     C                   ENDIF
 
     C                   IF        S2TZYR = *BLANKS OR
     C                             nCurrYear = nS2Year
     C                   MOVE      'Y'           cUPDFlag          1
     C                   IF        S2TZYR = *BLANKS
     C                   EVAL      D@TZYR = *BLANKS
     C     KSdtzlvL0A    CHAIN(N)  SDTZLVL0
     C                   ENDIF
     C                   IF        NOT %FOUND(SDTZLVL0)
     C                   MOVE      nCurrYear     D@TZYR
     C     KSdtzlvL0A    CHAIN(N)  SDTZLVL0
     C                   ENDIF
     C                   IF        %FOUND(SDTZLVl0)
     C                   EVAL      cUPDFlag  = 'N'
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDetails - Validate screen details entered.              *
      *                                                               *
      *  Called by: SRInsertLevel, SRPrSfl, SRAmend,                  *
      *                                                               *
      *  Calls: SRErrDta, AODSTCR0, SRCvtDt2                          *
      *                                                               *
      *****************************************************************
      *
     C     SRValDetails  BegSR
      *
      ** Short Description
      *
     C                   IF        DDDESC = *Blanks
     C                   EVAL      PMsgId = 'SWF0024'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *In51 = True
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Description
      *
     C                   IF        DDDDES = *Blanks And DDDESC <> *Blanks
     C                   EVAL      DDDDES = DDDESC
     C                   ENDIF
      *
      ** GMT Delta Time
      *
     C**********         IF        DDGMT = 0                                                BUG19136
     C**********         EVAL      PMsgId = 'SWF0025'                                       BUG19136
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19136
     C**********         EVAL      *In52 = True                                             BUG19136
     C**********         EXSR      SRErrDta                                                 BUG19136
     C**********         ENDIF                                                              BUG19136
 
     C                   IF        NOT(DDGMT >= 0  AND DDGMT <= 2359)
     C                   EVAL      PMsgId = 'SWF0026'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *In52 = True
     C                   EXSR      SRErrDta
     C                   ENDIF
                                                                                            BUG20043
     C                   MOVE      DDGMT         cDDGMT                                     BUG20043
     C                   IF        %SUBST(cDDGMT:1:2) <> *Blanks                            BUG20043
     C                   IF        %DEC(%SUBST(cDDGMT:1:2):2:0) > 23                        BUG20043
     C                   EVAL      PMsgId = 'SWF0052'                                       BUG20043
     C                   EVAL      WIdx = WIdx + 1                                          BUG20043
     C                   EVAL      *In52 = True                                             BUG20043
     C                   EXSR      SRErrDta                                                 BUG20043
     C                   ENDIF                                                              BUG20043
     C                   ENDIF                                                              BUG20043
                                                                                            BUG20043
     C                   IF        %SUBST(cDDGMT:3:2) <> *Blanks                            BUG20043
     C                   IF        %DEC(%SUBST(cDDGMT:3:2):2:0) > 59                        BUG20043
     C                   EVAL      PMsgId = 'SWF0052'                                       BUG20043
     C                   EVAL      WIdx = WIdx + 1                                          BUG20043
     C                   EVAL      *In52 = True                                             BUG20043
     C                   EXSR      SRErrDta                                                 BUG20043
     C                   ENDIF                                                              BUG20043
     C                   ENDIF                                                              BUG20043
      *
      ** GMT Delta Time Sign
      *
     C                   IF        DDGMTS <> '+' And DDGMTS <> '-'
     C                   EVAL      PMsgId = 'SWF0030'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *In53 = True
     C                   EXSR      SRErrDta
     C                   ENDIF
      *                                                                                     BUG19780
      ** GMT Delta Time Sign must be '+' if delta time is equal to 0                        BUG19780
      *                                                                                     BUG19780
     C                   IF        DDGMT = 0  And DDGMTS <> '+'                             BUG19780
     C                   EVAL      PMsgId = 'SWF0050'                                       BUG19780
     C                   EVAL      WIdx = WIdx + 1                                          BUG19780
     C                   EVAL      *In53 = True                                             BUG19780
     C                   EXSR      SRErrDta                                                 BUG19780
     C                   ENDIF                                                              BUG19780
      *
      ** Daylight Saving Time
      *
     C                   IF        DDDSTF <> 'Y' And DDDSTF <> 'N'
     C                   EVAL      PMsgId = 'SWF0027'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *In54 = True
     C                   EXSR      SRErrDta
     C                   ENDIF
 
     C                   IF        DDDSTF = 'N'
     C                             OR DDDSTF = ' '                                          BUG19780
     C                   EVAL      *In65 = False
     C                   ELSE
     C                   EVAL      *In65 = True
     C                   ENDIF
      *
      ** DST Code
      *
     C                   IF        DDDSTC = *Blanks And DDDSTF = 'Y'
     C                   EVAL      PMsgId = 'SWF0028'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *In55 = True
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** DST Code - Validate Value using access Object AODSTCR0.
      *
     C                   IF        DDDSTC <> *Blanks And DDDSTF = 'Y'
     C                   IF        S1TZYR = *BLANKS
     C                   MOVE      nCurrYear     PCurrYear         4
     C                   ELSE
     C                   EVAL      PCurrYear = S1TZYR
     C                   ENDIF
     C                   CALL      'AODSTCR0'
     C                   PARM      *Blanks       RetrnCode         7
     C                   PARM      '*VERIFY'     POption           7
     C                   PARM                    DDDSTC
     C                   PARM                    PCurrYear
     C                   PARM                    DSFDY
      *
      ** If return code is not equal to blank then its an invalid DST Code
      *
     C                   IF        RetrnCode <> *Blanks
     C                             Or DDDSTC = '?'                                          BUG19248
     C                   EVAL      PMsgId = 'SWF0028'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *In55 = True
     C                   EXSR      SRErrDta
     C                   Else
     C                   EVAL      SDDSTC = DSFDY
     C                   IF        DSYEAR <> %Char(nCurrYear)  And                          BUG19780
     C                             PCurrYear <> S1TZYR                                      BUG19780
     C                   EVAL      PMsgId = 'SWF0051'                                       BUG19780
     C                   EVAL      WIdx = WIdx + 1                                          BUG19780
     C                   EVAL      *In55 = True                                             BUG19780
     C                   EXSR      SRErrDta                                                 BUG19780
     C                   LEAVESR                                                            BUG19780
     C                   ENDIF                                                              BUG19780
     C                   EVAL      DDDSTD = DSDESC
     C                   IF        DSOFFS > 0
     C**********         Move      DSOFFS        DDDSTO                                     BUG19363
     C                   EVALR     DDDSTO = %CHAR(DSOFFS)                                   BUG19363
     C                   EVAL      DDDSDH = DSDSDH                                          BUG19849
     C                   EVAL      DDDENH = DSDENH                                          BUG19849
     C                   EVAL      *IN85 = *ON                                              BUG19849
     C
     C                   Z-Add     DSDSDT        MidasDayNo
     C                   EXSR      SRCvtDt2
     C                   Move      PDateOut      DDDSTS
 
     C                   Z-Add     DSDSED        MidasDayNo
     C                   EXSR      SRCvtDt2
     C                   Move      PDateOut      DDDSTE
      *
      ** Check If DST On (Current Date >= DSDSDT Current Date <= DSDSED
      *
     C                   IF        (BJRDNB >= DSDSDT) And (BJRDNB <= DSDSED)
     C                   EVAL      *IN84 = True                                 DST On
     C                   ELSE
     C                   EVAL      *IN84 = False                                DST Off
     C                   ENDIF
 
     C                   Else
     C                   EVAL      DDDSTO = *Blanks
     C                   ENDIF
 
     C                   ENDIF
 
     C                   Else
     C                   EVAL      DDDSTC  = *Blanks
     C                   EVAL      DDDSTD  = *Blanks
     C                   EVAL      DDDSTO  = *Blanks
     C                   EVAL      DDDSTS  = *Blanks
     C                   EVAL      DDDSTE  = *Blanks
     C                   EVAL      DDDSDH = *Zeros                                          BUG19849
     C                   EVAL      DDDENH = *Zeros                                          BUG19849
     C                   EVAL      *IN85  = *Off                                            BUG19849
 
     C                   ENDIF
     C                   IF        Widx = 0                                                 BUG19523
     C                   EXSR      SRGetLocalTime                                           BUG19523
     C                   ENDIF                                                              BUG19523
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopTabVal - Populate table field values for UPDATE         *
      *                                                               *
      *  Called by:  SRInsert, SRInsertLevel,  SRAmend,               *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPopTabVal   BEGSR
 
     C                   IF        WCurrentLevel <> 'T'
     C                   EVAL      TLTZLC = WCurrentLevel
     C                   EVAL      TLZONE = S1ZONE
     C                   EVAL      TLTZCD = S1TZCOD
     C                   EVAL      TLYEAR = S1TZYR
     C                   EVAL      TLDESC = DDDDES
     C                   EVAL      TLLCD  = BJRDNB
     C                   IF        WCurrentLevel = 'B'
     C                   EVAL      TLBRCA = S1BRCH
     C                   ELSE
     C                   EVAL      TLBRCA = *BLANKS
     C                   ENDIF
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      TLTMST = TimeStamp
     C                   EVAL      TLUSER = D0USER
     C                   ELSE
     C                   EVAL      TZTZCD = S1TZCOD
     C                   EVAL      TZTIBM = DDTIBM
     C                   EVAL      TZYEAR = S1TZYR
     C                   EVAL      TZSDSC = DDDESC
     C                   EVAL      TZDESC = DDDDES
     C                   EVAL      TZGMT  = DDGMT
     C                   EVAL      TZGMTS = DDGMTS
     C                   EVAL      TZDSTF = DDDSTF
     C                   EVAL      TZDSTC = DDDSTC
     C                   IF        DDDSTF <> 'Y'
     C                   EVAL      TZDSTC = *BLANKS
     C                   ENDIF
     C                   EVAL      TZLCD  = BJRDNB
     C                   EVAL      TZUSER = D0USER
     C                   CALLB     'ZAGENTMSTM'                                             BUG20731
     C                   PARM                    TimeStamp                                  BUG20731
     C                   EVAL      TZTMST = TimeStamp                                       BUG20731
     C                   ENDIF
 
     C**********         EXSR      SRChkDSTOffSet                                           BUG19624
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopScrVal - Populate screen field values for Disp/Upd      *
      *                                                               *
      *  Called by: SRSystemLevel, SRInsertLevel, SRPrSfl, SRInsert,  *
      *             SRCopyRecord                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPopScrVal   BEGSR
 
     C     KTZoneYear    CHAIN(N)  SDTIZOL0
     C                   IF        NOT %FOUND(SDTIZOL0)
     C     S1TZCOD       CHAIN(N)  SDTIZOL0
     C                   ENDIF
     C                   EVAL      S2TZCOD =  TZTZCD
     C                   EVAL      S2BRCH  =  TLBRCA
     C                   EVAL      DDTIBM  =  TZTIBM
     C                   IF        WCurrentLevel = 'T'
     C                   EVAL      DDDDES  =  TZDESC
     C                   ELSE
     C                   EVAL      D@TZLCD =  WCurrentLevel
     C                   EVAL      D@TZCOD =  S1TZCOD
     C     KSdtzlvL0     CHAIN(N)  SDTZLVL0
     C                   IF        %FOUND(SDTZLVL0)
     C                   EVAL      DDDDES  =  TLDESC
     C                   ELSE
     C                   EVAL      DDDDES  =  TZDESC
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      DDDESC  =  TZSDSC
     C                   EVAL      DDGMT   =  TZGMT
     C                   EVAL      DDGMTS  =  TZGMTS
     C                   EVAL      DDDSTF  =  TZDSTF
     C                   EVAL      DDDSTC  =  TZDSTC
     C                   EVAL      S2ZONE  =  TLZONE
     C                   IF        AddRecord = True                                         BUG20043
     C                   EVAL      S2TZYR  =  S1TZYR                                        BUG20043
     C                   ELSE                                                               BUG20043
     C                   IF        WCurrentLevel = 'T'                                      BUG21002
     C                   EVAL      S2TZYR  =  TZYEAR
     C                   ELSE                                                               BUG21002
     C                   EVAL      S2TZYR  =  TLYEAR                                        BUG21002
     C                   ENDIF                                                              BUG21002
     C                   ENDIF                                                              BUG20043
     C                   IF        DDDSTC  =  *BLANKS
     C                   EVAL      DDDSTD  = *Blanks
     C                   EVAL      DDDSTO  = *Blanks
     C                   EVAL      DDDSTS  = *Blanks
     C                   EVAL      DDDSTE  = *Blanks
     C                   ENDIF
 
     C**********         EXSR      SRChkDSTOffSet                                           BUG19624
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitScrVal - Initialize Screen Values (Refresh)            *
      *                                                               *
      *  Called by: SRInsertLevel, SRInsert,                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRInitScrVal  BEGSR
 
     C                   EVAL      DDTIBM  =  *BLANKS
     C                   EVAL      DDDESC  =  *BLANKS
     C                   EVAL      DDDDES  =  *BLANKS
     C                   EVAL      DDGMT   =  *ZEROS
     C                   EVAL      DDGMTS  =  *BLANK
     C                   EVAL      DDDSTF  =  *BLANK
     C                   EVAL      DDDSTC  =  *BLANKS
     C                   EVAL      DDDSTD  = *BLANKS
     C                   EVAL      DDDSTO  = *BLANKS
     C                   EVAL      DDDSTS  = *BLANKS
     C                   EVAL      DDDSTE  = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopHistDS - Populate history DS field values for UPDATE    *
      *                                                               *
      *  Called by: SRPrSfl                                           *
      *                                                               *
      *  Calls: SRCalcOff                                             *
      *                                                               *
      *****************************************************************
     C     SRPopHistDS   BEGSR
 
     C                   IF        WCurrentLevel = 'T'
     C                   CLEAR                   SDHISTDS
     C                   EVAL      hTHRECI  =  'D'
     C                   EVAL      hTHTZCD  =  TZTZCD
     C                   IF        TZYEAR = *BLANKS
     C                   EVAL      hTHYEAR  =  %Char(nCurrYear)
     C                   ELSE
     C                   EVAL      hTHYEAR  =  TZYEAR
     C                   ENDIF
     C                   EVAL      hTHDSTC  =  TZDSTC
     C                   EVAL      hTHDSTF  =  TZDSTF
     C                   MOVE      TZGMT         hTHGMTO
     C                   EVAL      hTHGMTS  =  TZGMTS
     C                   EVAL      hTHEFFS  =  TZGMTS
 
     C                   IF        hTHDSTF <> 'Y' AND TZDSTC <> *BLANKS
     C                   EVAL      hTHDSTC  =  *BLANKS
     C                   ENDIF
 
     C                   IF        DDDSTO <> *Blanks
 
     C                   EVAL      hTHDSTS  =  DSDSDT
     C                   EVAL      hTHDSTE  =  DSDSED
     C                   EVAL      hTHDSTO  =  DSOFFS
     C                   EVAL      hTHSTIM  =  DSDSDH
     C                   EVAL      hTHETIM  =  DSDENH
 
     C**********         EXSR      SRChkDSTOffSet                                           BUG19624
 
     C                   ELSE
     C                   EVAL      hTHDSTS  =  *ZEROS
     C                   EVAL      hTHDSTE  =  *ZEROS
     C                   EVAL      hTHDSTO  =  *ZEROS
     C                   EVAL      hTHSTIM  =  *ZEROS
     C                   EVAL      hTHETIM  =  *ZEROS
     C                   ENDIF
     C                   EVAL      hTHEFFO =   NewEffOffset
 
     C                   EVAL      hTHEFFD  =  BJRDNB
     C                   EVAL      hTHTYLC  =  wChgType
 
     C                   ELSE
 
     C                   IF        TLYEAR = *BLANKS
     C                   EVAL      TVYEAR =  %Char(nCurrYear)
     C                   ELSE
     C                   EVAL      TVYEAR =  TLYEAR
     C                   ENDIF
     C                   EVAL      TVRECI = TLRECI
     C                   EVAL      TVTZLC = TLTZLC
     C                   EVAL      TVZONE = TLZONE
     C                   EVAL      TVMICC = *BLANKS
     C                   EVAL      TVBRCA = TLBRCA
     C                   EVAL      TVTZCD = TLTZCD
     C                   EVAL      TVTZCD = TLTZCD
     C                   EVAL      TVEFFD =  BJRDNB
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      TVTMST = TimeStamp
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdateHist - Update changes made to history File            *
      *                                                               *
      * Called by: SRInsert                                           *
      *                                                               *
      * Calls: ZAGENTMSTM                                             *
      *                                                               *
      *****************************************************************
     C     SRUpdateHist  BEGSR
      *
      ** Compare history values for write/update of record.
      *
     C                   IF        SDTIZODS <> SDTIZODS2 And
     C                             WcurrentLevel = 'T'
     C                   CLEAR                   SDHIST
 
     C                   EXSR      SRChkChange
 
     C                   IF        HistUpdFlag = True
     C                   EXSR      SRValHistRec
 
     C                   ENDIF
 
     C                   ENDIF
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValHistRec - Validate if record is already written to       *
      *                history file for the day transaction.          *
      *                                                               *
      * Called by: SRPopHistDS                                        *
      *                                                               *
      * Calls: ZAGENTMSTM                                             *
      *                                                               *
      *****************************************************************
     C     SRValHistRec  BEGSR
 
     C                   IF        WCurrentLevel = 'T'
     C                   EVAL      D@TZYR = hTHYEAR
     C     KTZHist_T     CHAIN     SDTIZHL4
     C                   IF        %FOUND(SDTIZHL4)
     C                   EVAL      THRECI = '*'
     C                   UPDATE    RSDTIZ_L4
     C                   ENDIF
     C                   MOVE      SDHISTDS      SDHIST
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      THTMST = TimeStamp
     C                   EVAL      THRECI = 'D'
     C                   EVAL      THTYLC = wChgType
 
     C                   WRITE     RSDTIZ_L4
 
     C                   ELSE
 
     C                   EVAL      D@TZYR = hTHYEAR
     C     KTLHist_L     CHAIN     SDTZLHL3
     C                   IF        %FOUND(SDTZLHL3)
     C                   EVAL      TVRECI = '*'
     C                   UPDATE    RSDTLH_H3
     C                   ENDIF
     C                   EVAL      TVTZCD = TLTZCD                                          BUG19141
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      TVTMST = TimeStamp
     C                   EVAL      TVRECI = 'D'
 
     C                   WRITE     RSDTLH_H3
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkDSTOffSet - Check if offset is within DST Period         *
      *                                                               *
      * Called by: SRPopHistDS                                        *
      *                                                               *
      * Calls: SRCalcOff                                              *
      *                                                               *
      *****************************************************************
     C     SRChkDSTOffSetBEGSR
      *
      ** Compute for DST Offse
      *
     C                   MOVE      TZGMTS        GMTSign           1
     C                   EVAL      NewEffOffset = TZGMT
     C                   IF        DSOFFS > 0
     C                   IF        BJRDNB >= DSDSDT AND
     C                             BJRDNB <= DSDSED
 
     C                   EVAL      WOfSt = DSOFFS
     C                   EXSR      SRCalcOff
     C                   MOVEL     WTime1        NewEffOffset      4 0
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalcOff - Calculate Offset                                  *
      *                                                               *
      * Called by: SRPopHistDS                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCalcOff     BEGSR
      *
      ** Calculate Effective Offset
      *
     C                   EVAL      WTmpOffset = TZGMT
     C                   MOVEL     '000000'      WTmp
     C                   MOVEL     WTmpOffset    WTmp
     C                   EVAL      WTime = %TIME(WTmp:*HMS0)
     C                   EVAL      WTime_M = WTime                                         BUG19524A
     C                   IF        (TZGMTS = '+')
     C                   ADDDUR    WOfSt:*MN     WTime
     C                   ELSE
     C                   SUBDUR    WOfSt:*MN     WTime
     C                   IF        Wtime > Wtime_M                                         BUG19524A
     C                   MOVE      WTIME         RTIME             6 0                     BUG19524A
     C                   EVAL      WTime_H = WTime_H - Rtime                               BUG19524A
     C                   MOVEL     WTime_H       Wtmp                                      BUG19524A
     C                   EVAL      WTime = %TIME(Wtmp:*HMS0)                               BUG19524A
     C                   RESET                   WTime_H                                   BUG19524A
     C                   ENDIF                                                             BUG19524A
     C                   ENDIF
     C                   EVAL      WTime1  = %Char(WTime:*Hms0)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcAction - Process selected action code.                 *
      *                                                               *
      *  Called by:  SRPrSfl,                                         *
      *                                                               *
      *  Calls: SRAmend, SRDelete, SRCopyRecord,  SRBrchLvlUpd,       *
      *         ZA0250                                                *
      *                                                               *
      *****************************************************************
     C     SRProcAction  Begsr
 
     C   89              SetOn                                        8931
 
     C                   SELECT
     C                   WHEN      POpt = Amend
     C                   EXSR      SRAmend
 
     C                   WHEN      POpt = Enquire
     C                   EVAL      *IN79 = True
     C                   SETOFF                                       8931                  BUG19910
     C                   DOW       Exit = False AND Cancel = False
     C                   WRITE     SDM01005F0
     C                   EXFMT     SDM01005D3
     C                   EXSR      SRValDetails                                             BUG19523
     C                   ENDDO
     C                   EVAL      *IN79 = False
     C                   IF        Exit = True
     C                   EVAL      EndPGMFlag = True
     C                   ENDIF
     C                   EVAL      Cancel = True
 
     C                   WHEN      POpt = Delete
     C                   EXSR      SRDelete
 
     C                   WHEN      POpt = Copy                                              BUG19523
     C                   IF        WCurrentLevel = 'T'                                      BUG19523
     C                   EXSR      SRCopyRecord                                             BUG19523
     C                   ENDIF                                                              BUG19523
                                                                                            BUG19523
     C                   ENDSL
 
     C                   EVAL      *In31 = False
     C**********         EVAL      WSavModeInd = *In89                                      BUG19910
     C                   EVAL      *In89 = WSavModeInd                                      BUG19910
     C                   IF        Cancel = True and WCurrentLevel='B'
     C                   EVAL      Cancel = False
     C                   ENDIF
     C                   IF        Exit = True
     C                   EVAL      EndPGMFlag = True
     C                   ENDIF
      *
      ** Clear Program Message Queue
      *
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtDt - Convert Date to Midas Day Format                   *
      *                                                               *
      *  Called by: SRValDetails                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCvtDt       BEGSR
      *
     C**********         CALL      'ZDATE1'                                                 BUG19523
     C                   CALLB     'ZDATE1'                                                 BUG19523
     C                   PARM                    PZDate
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PErrorFlag
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtDt2 - Convert Midas Day Format to DDMMYY/MMDDYY         *
      *                                                               *
      *  Called by: SRValDetails                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCvtDt2      BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    MidasDayNo        5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDateOut          6 0
     C                   PARM      *BLANKS       PADateOut         7
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetLocalTime - Get Local or Market Time                    *
      *                                                               *
      *  Called by: SRPrSfl                                           *
      *                                                               *
      *  Calls: SDMFIDTIM                                             *
      *                                                               *
      *****************************************************************
     C     SRGetLocalTimeBegsr
 
     C                   IF        PDate1 = *Blanks
     C                   CALL      'ZDATE2'
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDateOut          6 0
     C                   PARM      *BLANKS       PADateOut         7
 
     C                   Move      PDateOut      PDate1
     C                   ENDIF
     C**********         IF        AddRecord = True                                BUG20043 BUG21017
     C                   IF        AddRecord = True Or D0OPT = Amend                        BUG21017
     C                   EVAL      GMTSign = DDGMTS                                         BUG20043
     C                   EVAL      NewEffOffset = DDGMT                                     BUG20043
     C                   EVAL      TZGMT  = DDGMT                                           BUG20043
     C                   EVAL      TZGMTS = DDGMTS                                          BUG20043
     C                   ELSE                                                               BUG20043
     C                   MOVE      TZGMTS        GMTSign                                    BUG19624
     C                   EVAL      NewEffOffset = TZGMT                                     BUG19624
     C                   ENDIF                                                              BUG20043
      ** Retrieve sign of Offset of Market based on Time Zone and DST Code.
     C                   CALL      'SDMFIDTIM'
      * Input Parameter
     C                   PARM      '05'          POpType
     C                   PARM                    PDate1
     C                   PARM      *Blanks       PTime1
     C                   PARM      *Blanks       PSign1
     C                   PARM      *Blanks       POffSet1
     C                   PARM      *Blanks       PDate2
     C                   PARM      *Blanks       PTime2
     C                   PARM      *Blanks       PSign2
     C                   PARM      *Blanks       POffSet2
     C                   PARM                    PBrc
     C                   PARM      *Blanks       PMicCode
      *
      ** Retrieve Current Offset                                                            BUG21071
      *                                                                                     BUG21071
     C                   Eval      cCurrSysSign  = PSign1                                   BUG21071
     C                   Move      POffset1      nCurrSysOffs                               BUG21071
      *                                                                                     BUG21071
      ** Get Transaction Date
      *
     C                   IF        PTime1 = *BLANKS
     C                   Move      D0TIME        PTime1
     C                   ENDIF
      *
      ** Get Branch Effective Offset
      *
     C**********         EVAL      S2OFFSET = Psign1+Poffset1                               BUG19243
     C**********         EVAL      S2OFFSET = Psign1 + %Subst(Poffset1:1:2)        BUG19243 BUG19426
     C**********                    + ':' + %Subst(Poffset1:3:2)                   BUG19243 BUG19426
     C                   IF        DDDSTC <> *Blanks And DDDSTF = 'Y'                       BUG19523
     C                   IF        BJRDNB >  DSDSDT AND                                     BUG19426
     C                             BJRDNB <  DSDSED                                         BUG19426
     C                   EXSR      SRChkDSTOffSet
     C                   MOVE      NewEffOffset  POffset2          4
     C                   EVAL      *IN84 = True                                             BUG19780
     C                   ELSE                                                               BUG19426
     C                   MOVE      TZGMT         Poffset2                                   BUG19426
     C                   ENDIF                                                              BUG19426
     C                   ELSE                                                               BUG19523
     C                   MOVE      TZGMT         Poffset2                                   BUG19523
     C                   EVAL      *IN84 = False                                            BUG19780
     C                   ENDIF                                                              BUG19523
      *
      ** Convert system time to local or market Time
      *
     C                   CALL      'SDMFIDTIM'
     C                   PARM      '02'          POpType
     C                   PARM                    PDate1
     C                   PARM                    PTime1
     C                   PARM                    PSign1
     C                   PARM                    POffSet1
     C                   PARM      *Blanks       PDate2
     C                   PARM      *Blanks       PTime2
     C                   PARM                    DDGMTS
     C                   PARM                    POffset2
     C                   PARM                    PBrc
     C                   PARM      *Blanks       PMicCode
 
     C                   IF        WCurrentLevel = 'S'                                      BUG19143
     C                   EVAL      WSwTime = %TIME()                                        BUG19143
     C                   EVAL      WCwTime = %CHAR(WSwTime:*ISO0)                           BUG19143
     C**********         EVAL      DDCRTM = WCwTime                                BUG19143 BUG19243
     C                   Move      WCwTime       DDCRTM                                     BUG19243
     C                   ELSE                                                               BUG19143
     C**********         EVAL      DDCRTM = PTime2                                          BUG19243
     C                   Move      PTime2        DDCRTM                                     BUG19243
     C                   ENDIF                                                              BUG19143
      *                                                                                     BUG19523
      ** Check if date1 and date2 after conversion of local market time                     BUG19523
     C                   EVAL      PZDate =  PDate1                                         BUG19523
     C                   EXSR      SRCvtDt                                                  BUG19523
     C                   Eval      nPDate1 = PZDayno                                        BUG19523
      *                                                                                     BUG19523
     C                   EVAL      PZDate =  PDate2                                         BUG19523
     C                   EXSR      SRCvtDt                                                  BUG19523
      *                                                                                     BUG19523
     C                   IF        DDDSTC <> *Blanks And DDDSTF = 'Y'                       BUG19523
      *                                                                                     BUG19426
      ** Check if DST On. Computed time must be >= Start time. And End Time must be         BUG19426
      ** less than or equal to computed time.                                               BUG19426
      *                                                                                     BUG19426
     C                   IF        (BJRDNB = DSDSDT  And DSDSDH > 0) Or                     BUG19426
     C                             (BJRDNB = DSDSED  And DSDENH > 0)                        BUG19426
     C                   IF        (BJRDNB = DSDSDT  And DSDSDH > 0)                        BUG19426
     C                   IF        DDCRTM < DSDSDH                                          BUG19426
     C                   EVAL      *In84 = False                                            BUG19426
     C                   ENDIF                                                              BUG19426
     C                   ENDIF                                                              BUG19426
     C                   IF        (BJRDNB = DSDSED  And DSDENH > 0)                        BUG19426
     C                   IF        DDCRTM > DSDENH                                          BUG19426
     C                   EVAL      *In84 = False                                            BUG19426
     C                   ENDIF                                                              BUG19426
     C                   ENDIF                                                              BUG19426
      *                                                                                     BUG19523
      ** Computed time is behind the Current Date. Set DST to ON                            BUG19523
     C                   IF        PZDayno < nPDate1                                        BUG19523
     C                   EVAL      *In84 = True                                             BUG19523
     C                   ENDIF                                                              BUG19523
      *                                                                                     BUG19426
      ** If DST is ON. Recompute local or market Time.                                      BUG19426
     C                   IF        *In84 = True                                             BUG19426
     C                   EXSR      SRChkDSTOffSet                                           BUG19426
     C                   MOVE      NewEffOffset  POffset2                                   BUG19426
      *                                                                                     BUG19426
      ** Convert system time to recompute local or market Time.                             BUG19426
      *                                                                                     BUG19426
     C                   CALL      'SDMFIDTIM'                                              BUG19426
     C                   PARM      '02'          POpType                                    BUG19426
     C                   PARM                    PDate1                                     BUG19426
     C                   PARM                    PTime1                                     BUG19426
     C                   PARM                    PSign1                                     BUG19426
     C                   PARM                    POffSet1                                   BUG19426
     C                   PARM      *Blanks       PDate2                                     BUG19426
     C                   PARM      *Blanks       PTime2                                     BUG19426
     C                   PARM                    DDGMTS                                     BUG19426
     C                   PARM                    POffset2                                   BUG19426
     C                   PARM                    PBrc                                       BUG19426
     C                   PARM      *Blanks       PMicCode                                   BUG19426
      *                                                                                     BUG19426
     C                   MOVE      PTime2        DDCRTM                                     BUG19426
     C                   MOVE      NewEffOffset  POffset1                                   BUG19426
     C                   ENDIF                                                              BUG19426
     C                   ELSE                                                               BUG19780
     C                   MOVE      NewEffOffset  POffset1                                   BUG19780
     C                   ENDIF                                                              BUG19426
     C                   ENDIF                                                              BUG19523
      *                                                                                     BUG19426
     C                   IF        *In84 = False                                            BUG19426
     C                   MOVE      TZGMT         POffset1                                   BUG19426
     C                   MOVE      TZGMTS        GMTSign                                    BUG19426
     C                   ENDIF                                                              BUG19426
     C                   IF        AddRecord = True                                         BUG20043
     C                   EVAL      GMTSign  =  DDGMTS                                       BUG20043
     C                   ENDIF                                                              BUG20043
     C                   IF        Poffset1 = '0000'                                        BUG19780
     C                   EVAL      S2OFFSET = '+' + %Subst(Poffset1:1:2)                    BUG19780
     C                              + ':' + %Subst(Poffset1:3:2)                            BUG19780
     C                   ELSE                                                               BUG19780
     C                   EVAL      S2OFFSET = GMTSign + %Subst(Poffset1:1:2)                BUG19426
     C                              + ':' + %Subst(Poffset1:3:2)                            BUG19426
     C                   ENDIF                                                              BUG19780
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValBranch - Validate branch code.                          *
      *                                                               *
      *  Called by: SRFldVal, SRValDelete                             *
      *                                                               *
      *  Calls: AOBRCHR1                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRValBranch   BEGSR
 
     C                   Call      'AOBRCHR1'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      S1BRCH        PBrCd
     C                   PARM                    DSSDY
 
     C                   IF        (PRtcd  <> *Blanks)
     C                   EVAL      PMsgId = 'ASM0006'
     C                   EVAL      *IN56 = True
     C                   EVAL      Widx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   Else
     C**********         Move      DSSDY         SDBRCH                                     BUG19248
     C                   MoveL     DSSDY         SDBRCH                                     BUG19248
     C                   EVAL      WLocCode = A8LCCD
     C                   EVAL      S1BRCH   = A8BRCD                                        BUG19523
     C                   ENDIF
      *
      ** Validate if branch already exist in time zone file
      *
     C     KSBranch      CHAIN(N)  SDTZLVL0
     C                   IF        %FOUND(SDTZLVL0) And AddRecord = True
     C                   EVAL      PMsgId = 'SWF0036'
     C                   EVAL      *IN56 = True
     C                   EVAL      Widx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C
     C                   ENDSR
      *
      *****************************************************************                     BUG19910
      /EJECT                                                                                BUG19910
      *****************************************************************                     BUG19910
      *                                                               *                     BUG19910
      *  SRUpdBrchLog - Update branch trailer file for any changes    *                     BUG19910
      *                                                               *                     BUG19910
      *  Called by:                                                   *                     BUG19910
      *                                                               *                     BUG19910
      *  Calls: TABLETR, ZASNMS                                       *                     BUG19910
      *                                                               *                     BUG19910
      *****************************************************************                     BUG19910
     C     SRUpdBrchLog  BEGSR                                                              BUG19910
      *                                                                                     BUG19910
     C                   MOVEL     *BLANK        W0RTN             7                        BUG19910
      *                                                                                     BUG19910
      ** Move key fields to @AHREAU                                                         BUG19910
     C                   MOVEL     'SDBRCHPD'    Filename         10                        BUG19910
      *                                                                                     BUG19910
     C     Filename      CHAIN     SDFCTLL0                                                 BUG19910
     C                   IF        %Found(SDFCTLL0)                                         BUG19910
      ** Increment number of Amendments.                                                    BUG19910
     C                   EVAL      AHNOAM = AHNOAM + 1                                      BUG19910
     C                   UPDATE    @AHREAU                                                  BUG19910
     C                   ENDIF                                                              BUG19910
      ** TABLETR - Branch Codes  *                                                          BUG19910
     C                   CALL      'TABLETR'                            90                  BUG19910
     C     W0RTN         PARM      *BLANK        WQ0041            7                        BUG19910
     C                   PARM      A8BRCD        WQ0042            3                        BUG19910
     C                   PARM      A8CMCD        WQ0043            3                        BUG19910
     C                   PARM      A8LCCD        WQ0044            3                        BUG19910
     C                   PARM      A8DFAC        WQ0045            4                        BUG19910
     C                   PARM      A8DTAC        WQ0046            4                        BUG19910
     C                   PARM      A8BICN        WQ0047            6                        BUG19910
     C                   PARM      A8LCD         WQ0048            5 0                      BUG19910
     C                   PARM      A8TYLC        WQ0049            1                        BUG19910
     C                   PARM      A8BRNM        WQ0050           30                        BUG19910
     C                   PARM      A8GBCD        WQ0051            3                        BUG19910
     C                   PARM      A8BRSN        WQ0052            3                        BUG19910
      *                                                                                     BUG19910
     C                   IF        *IN90 = True                                             BUG19910
      ** Send message '*Error occured on CALL...'                                           BUG19910
     C                   EVAL      PMsgId = 'Y2U0032'                                       BUG19910
     C                   EVAL      WIdx = WIdx + 1                                          BUG19910
     C                   EXSR      SRErrDta                                                 BUG19910
     C                   ENDIF                                                              BUG19910
      ** CASE: PGM.*Return code is Old Table Error                                          BUG19910
     C                   IF        W0RTN = '*ERROR*'                                        BUG19910
      ** Send message 'Unable to update'                                                    BUG19910
     C                   EVAL      PMsgId = 'USR0015'                                       BUG19910
     C                   EVAL      WIdx = WIdx + 1                                          BUG19910
     C                   EXSR      SRErrDta                                                 BUG19910
     C                   GOTO      ENDTAG                                                   MD035941
      *                                                                                     BUG19910
     C                   ENDIF                                                              BUG19910
     C**********         IF        *IN90 = False And W0RTN = *Blanks               BUG19910 BUG21289
     C                   IF        (*IN90 = False And W0RTN = *Blanks  And                  BUG21289
     C                             AllBrchUPDATE = True) OR                                 BUG21289
     C                             (*IN90 = False And W0RTN = *Blanks  And                  BUG21289
     C                              LocBrchUPDATE = True) OR                                BUG21289
     C                              cUpdBrchFlag = 'Y'                                      BUG21289
     C                   COMMIT                                                             BUG19910
     C                   ELSE                                                               BUG19910
     C                   ROLBK                                                              BUG19910
     C                   ENDIF                                                              BUG19910
      *                                                                                     BUG19910
     C**********         ENDSR                                                     BUG19910 MD035941
     C     ENDTAG        ENDSR                                                              MD035941
      *                                                                                     BUG19910
      *****************************************************************                     BUG19138
      /EJECT                                                                                BUG19138
      *****************************************************************                     BUG19138
      *                                                               *                     BUG19138
      *  SRValTimeZone -  Validate time zone code used on branch,     *                     BUG19138
      *                   system and Zone Levels.                     *                     BUG19138
      *                                                               *                     BUG19138
      *  Called by: SRFldVal                                          *                     BUG19138
      *                                                               *                     BUG19138
      *  Calls: AOTIZORO                                              *                     BUG19138
      *                                                               *                     BUG19138
      *****************************************************************                     BUG19138
      *                                                                                     BUG19138
     C     SRValTimeZone BEGSR                                                              BUG19138
                                                                                            BUG19138
     C                   MOVE      S1TZYR        PcTZYear          4                        BUG20043
     C                   MOVE      S1TZYR        TpTZYear          4                        BUG21225
     C                   CALL      'AOTIZOR0'                                               BUG19138
     C                   PARM      *BLANKS       PRtcd                                      BUG19138
     C                   PARM      '*KEY'        POptn                                      BUG19138
     C                   PARM                    S1TZCOD                                    BUG19138
     C**********         PARM                    S1TZYR                            BUG19138 BUG21225
     C                   PARM                    TpTZYear                                   BUG21225
     C                   PARM                    SDTIZODS                                   BUG19138
      *                                                                                     BUG19138
     C**********         IF        PRtcd  <> *BLANKS                               BUG19138 BUG21225
     C                   IF        PRtcd  <> *BLANKS  OR                                    BUG21225
     C                             (PRtcd  = *BLANKS  AND Addrecord = True  AND             BUG21225
     C                             S1TZYR <> TpTZYear AND S1TZCOD = TZTZCD  AND             BUG21225
     C                             TpTZYear <> *BLANKS)                                     BUG21225
     C                   EVAL      PMsgId = 'SWF0032'                                       BUG19138
     C                   EVAL      WIdx = WIdx + 1                                          BUG19138
     C                   EVAL      *IN50 = True                                             BUG19138
     C                   EVAL      *IN57 = True                                             BUG21225
     C                   EXSR      SRErrDta                                                 BUG19138
     C                   ELSE                                                               BUG19138
     C                   IF        Addrecord = True And PcTZYear <> *Blanks                 BUG20043
     C                   EVAL      S1TZYR = PcTZYear                                        BUG20043
     C                   ELSE                                                               BUG21225
     C                   EVAL      S1TZYR = TpTZYear                                        BUG21225
     C                   ENDIF                                                              BUG20043
     C                   EVAL      D@TZCOD = S1TZCOD                                        BUG19138
     C                   EVAL      D@TZYR  = S1TZYR                                         BUG19138
     C                   ENDIF                                                              BUG19138
      *                                                                                     BUG19138
     C                   ENDSR                                                              BUG19138
      *                                                                                     BUG19138
      *****************************************************************                     BUG19400
      /EJECT                                                                                BUG19400
      *****************************************************************                     BUG19400
      *                                                               *                     BUG19400
      *  SRValZone -  Validate zone code used on Zoned Level          *                     BUG19400
      *                                                               *                     BUG19400
      *  Called by: SRFldVal                                          *                     BUG19400
      *                                                               *                     BUG19400
      *  Calls:                                                       *                     BUG19400
      *                                                               *                     BUG19400
      *****************************************************************                     BUG19400
      *                                                                                     BUG19400
     C     SRValZone     BEGSR                                                              BUG19400
     C                   EVAL      *IN58 = False                                            BUG19400
     C**********         IF        S1ZONE <> *Blanks                               BUG19400 BUG20043
     C     *LOVAL        SETLL     GPZONEL1                                                 BUG19400
     C     S1ZONE        CHAIN(N)  GPZONEL1                                                 BUG19400
     C                   IF        Not %Found(GPZONEL1)                                     BUG19400
     C                   EVAL      PMsgId = 'SWF0044'                                       BUG19400
     C                   EVAL      WIdx = WIdx + 1                                          BUG19400
     C                   EVAL      *IN58 = True                                             BUG19400
     C                   EXSR      SRErrDta                                                 BUG19400
     C                   ENDIF                                                              BUG19400
     C**********         ENDIF                                                     BUG19400 BUG20043
     C                   ENDSR                                                              BUG19400
                                                                                            BUG19400
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRecFilter - Filter Records based selection criteria        *
      *                                                               *
      *  Called by: SRLoadSfl                                         *
      *                                                               *
      *  Calls: QCLSCAN                                               *
      *                                                               *
      *****************************************************************
     C     SRRecFilter   Begsr
 
      *
      ** Time Zone Code filter is not Blank
      *
     C                   IF        H@TZCOD <> *Blanks
     C                   EVAL      PLenTabFld = %LEN(TZTZCD)
     C                   EVAL      PLenScrFld = %LEN(H@TZCOD)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TZTZCD
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    H@TZCOD
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectYN = 'N'
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Year Filter Is Not Blanks
      *
     C                   IF        H@TZYR  <> *Blanks
     C                   EVAL      PLenTabFld = %LEN(TZYEAR)
     C                   EVAL      PLenScrFld = %LEN(H@TZYR)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TZYEAR
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    H@TZYR
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectYN = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Short Desc Filter Is Not Blanks
      *
     C                   IF        H@SDES  <> *Blanks
     C                   EVAL      PLenTabFld = %LEN(TZSDSC)
     C                   Eval      PLenScrFld = %LEN(H@SDES)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TZSDSC
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    H@SDES
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectYN = 'N'
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Delta Time Filter Is Not Blanks
      *
     C                   IF        H@GMT   <> *Blanks
     C                   EVAL      PLenTabFld = %LEN(D@DTIME)
     C                   EVAL      PLenScrFld = %LEN(H@GMT)
     C                   Move      D@dtime       Ddtmechar                                  BUG21039
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C**********         PARM                    D@DTIME                                    BUG21039
     C                   Parm                    Ddtmechar                                  BUG21039
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    H@GMT
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectYN = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                     BUG19523
      ** GMT Sign Filter Is Not Blanks                                                      BUG19523
      *                                                                                     BUG19523
     C                   IF        H@GMTS  <> *Blanks                                       BUG19523
     C                   EVAL      PLenTabFld = %LEN(TZGMTS)                                BUG19523
     C                   EVAL      PLenScrFld = %LEN(H@GMTS)                                BUG19523
      *                                                                                     BUG19523
      ** Scan Database Field With the Search Argument                                       BUG19523
      *                                                                                     BUG19523
     C                   CALL      'QCLSCAN'                                                BUG19523
     C                   PARM                    TZGMTS                                     BUG19523
     C                   PARM                    PLenTabFld                                 BUG19523
     C                   PARM                    PStart                                     BUG19523
     C                   PARM                    H@GMTS                                     BUG19523
     C                   PARM                    PLenScrFld                                 BUG19523
     C                   PARM                    PTranslate                                 BUG19523
     C                   PARM                    PTrim                                      BUG19523
     C                   PARM                    PWild                                      BUG19523
     C                   PARM                    PResult                                    BUG19523
      *                                                                                     BUG19523
      ** If Not Present,Blank Out Screen Field                                              BUG19523
      *                                                                                     BUG19523
     C                   IF        PResult < 1                                              BUG19523
     C                   EVAL      WSelectYN = 'N'                                          BUG19523
      *                                                                                     BUG19523
      ** If Present Display That Record                                                     BUG19523
      *                                                                                     BUG19523
     C                   ELSE                                                               BUG19523
     C                   EVAL      WSelectYN = 'Y'                                          BUG19523
     C                   ENDIF                                                              BUG19523
      *                                                                                     BUG19523
     C                   ENDIF                                                              BUG19523
      *
      ** DST Code Filter Is Not Blanks
      *
     C                   IF        H@DSTC  <> *Blanks
     C                   EVAL      PLenTabFld = %LEN(TZDSTC)
     C                   EVAL      PLenScrFld = %LEN(H@DSTC)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TZDSTC
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    H@DSTC
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectYN = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdRecords - Determine if record should be written or not  *                     BUG21226
      *                                                               *                     BUG21226
      *  Called by: SRInsertLevel, SRAmend                            *                     BUG21226
      *                                                               *                     BUG21226
      *  Calls: None                                                  *                     BUG21226
      *                                                               *                     BUG21226
      *****************************************************************                     BUG21226
      *                                                                                     BUG21226
     C     SRUpdRecords  BEGSR                                                              BUG21226
     C                   IF        (*IN90 = False And W0RTN = *Blanks  And                  BUG21226
     C                             WSaveRecord = 'Y') Or                                    BUG21226
     C                             (*IN90 = False And W0RTN = *Blanks  And                  BUG21226
     C                              RecUpdFlag = 'Y' And Cancel = False) Or                 BUG21226
     C                              cUpdBrchFlag = 'Y'                                      BUG21226
     C                   COMMIT                                                             BUG21226
     C                   ELSE                                                               BUG21226
     C                   ROLBK                                                              BUG21226
     C                   ENDIF                                                              BUG21226
      *                                                                                     BUG21226
     C                   ENDSR                                                              BUG21226
      *                                                                                     BUG21226
      *****************************************************************                     BUG21226
      /EJECT                                                                                BUG21226
      *****************************************************************                     BUG21226
      *                                                               *                     BUG21226
      *  SRSnms - Send error message to program message Queue         *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRSnms        BEGSR
      *
      ** Send message '*No value selected'
     C                   MOVEL     'Y2U0016'     PZAMsid
     C                   MOVEL     'Y2USRMSG'    PZAMsgf
     C                   MOVEL     '*PRV '       PZAPgrl
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      'SD001005'    PZAPgm
     C                   PARM                    PZAPgrl
     C                   PARM                    PZAMsid
     C                   PARM                    PZAMsgf
     C                   PARM                    PZAMsda
     C                   PARM                    PZAMstp
      *
      ** Clear all fields for default mechanism next time.
     C                   EVAL      PZAPgm = *BLANKS
     C                   EVAL      PZAPgrl = *BLANKS
     C                   EVAL      PZAMsid = *BLANKS
     C                   EVAL      PZAMsgf = *BLANKS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANKS
      *
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = True
     C                   EVAL      *INU8 = True
     C                   EVAL      *INLR = True
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
