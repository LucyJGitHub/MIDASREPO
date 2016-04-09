     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Migrate Items from MITEM to SFMENUPD')        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1080 - Migrate menu items from MITEM to SFMENUPD           *
      *                                                               *
      *  Function:  If the Migrate option is '*YES', this program     *
      *             will migrate menu items from MITEM to SFMENUPD,   *
      *             GPMTXTPD, SMSFCVPD and SCSARIPD from the old      *
      *             system to the new GP system.  Discrepancy         *
      *             eports by MGRP ICDE is generated.  Duplicate      *
      *             PCMD PARA items are output to SMDPGMPD and new    *
      *             items in MITEMDD for migration to SFMENUPD are    *
      *             output to SMMIGIPD for reporting purpose.         *
      *                                                               *
      *  Called By: SMC1080                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR936709           Date 19Mar12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK019             Date 06Jul04               *
      *                 CSF002  *CREATE    Date 25Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR936709 - Replacement file for UPSARIPD.                    *
      *  CPK019 - Post-implementation changes.                        *
      *  CSF002 - Global Processing changes for SPF.                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *       10      End of file SDMMIDL2                            *
      *       20      End of files SMITEMPD, SMITEML0                 *
      *       22      End of files SMITEML0 in SR. ChkDuplicate       *
      ********29******Chain*-*record*not*found*(UPSARIL1)**************                     AR936709
      *       29      Chain - record not found (SMSARIPD)             *                     AR936709
      *       30      Chain - record not found (SMSFCVL0, SMSFCVL2)   *
      *       31      Match MGRP/ICDE record found in SMSFCVL0        *
      *       32      Conversion record matching PCMD, PARA but not   *
      *               matching MGRP ICDE found.                       *
      *       33      Matched PCMD/PARA, MGRP/ICDE record found in    *
      *               SMSFCVL2                                        *
      *       35      End of file  SMSFCVL2                           *
      *       45      Duplicated PCMD/PARA in SMITEML0                *
      *       60      Midas module installed (ie,Module found in @Mods*
      *       68      Different action codes to report                *
      *       71      There is record to report in SM1080P1           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * ChkItemsByGrp - Check items by MGRP, ICDE. Print any different*
      *                 PCMD, PARA to SM1080P1 nad different action   *
      *                 codes to SM1080P2.                            *
      * CompareActCod - Compare action codes and report any difference*
      *                 to SM1080P2.                                  *
      * ChkItemsByCmd - Check items by PCMD, PARA. Output duplicate   *
      *                 PCMD, PARA to SMDPGMPD. Output new PCMD PARA  *
      *                 MRPG ICDE to SFMENUPD, SMSFCVPD, GPMTXTPD and *
      *                 SCSARIPD.                                     *
      * ChkDuplicate  - Set on *IN45 for any duplicate PCMD PARA in   *
      *                 SMITEML0.                                     *
      * ChkIgnored    - Check if all conversion records with same     *
      *                 PCMD and PARA have been ignored.              *
      * WrtDPGMD0     - Output record to SMDPDMPD file for duplicate  *
      *                 matched PCMD PARA, but unmatched group item.  *
      * ChkGrpInConv  - output recs to SFMENUPD, GPMTXTPD, SMSFCVPD   *
      *                 for any unique PCMD PARA item and its MGRP    *
      *                 ICDE does not exist in conversion file.       *
      * WrtNewRecs    - Write new records to files SFMENUPD, GPMTXTPD,*
      *                 SMSFCVPD and SCSARIPD.                        *
      * WrtSFRecs     - Copy records with same MGRP and ICDE from     *
      ******************UPSARIL1*to*SCSARIPD.**************************                     AR936709
      *                 SMSARIPD to SCSARIPD.                         *                     AR936709
      * *INZSR        - Initialise                                    *
      * LoadModSName  - Load @Mods and @ShortNames arrays from        *
      *                 Installed Midas Modules Information file      *
      *  *PSSR        - Error processing                              *
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
 
     FSDMMIDL2  IF   E           K DISK    INFSR(*PSSR)
     FSMITEMPD  IF   E           K DISK    INFSR(*PSSR)                         by MGRP, ICDE unique
     FSMITEML0  IF   E           K DISK    INFSR(*PSSR)                         by PCMD PARA
     F                                     RENAME(MITEMDDF:ITEML0F)                MGRP ICDE unique
     FSMSFCVL0  IF   E           K DISK    INFSR(*PSSR)                         by MGRP, ICDE unique
     FSMSFCVL2  IF   E           K DISK    INFSR(*PSSR)                         by PCMD PARA
                                                                                   MGRP ICDE unique
     F***UPSARIL1**IF   E           K DISK    INFSR(*PSSR)                      by PCMD PAR AR936709
     FSMSARIPD  IF   E           K DISK    INFSR(*PSSR)                                     AR936709
     F                                     RENAME(SCSARID0:SARIF)                           AR936709
 
     F*SFMENUPD*O****E             DISK    INFSR(*PSSR)                                       CPK019
     F*GPMTXTPD*O****E             DISK    INFSR(*PSSR)                                       CPK019
     F*SMSFCVPD*O****E             DISK    INFSR(*PSSR)                                       CPK019
     F*SCSARIPD*O****E             DISK    INFSR(*PSSR)                                       CPK019
     FSFMENUPD  O    E             DISK    INFSR(*PSSR) USROPN                                CPK019
     FGPMTXTPD  O    E             DISK    INFSR(*PSSR) USROPN                                CPK019
     FSMSFCVPD  O    E             DISK    INFSR(*PSSR) USROPN                                CPK019
     FSCSARIPD  O    E             DISK    INFSR(*PSSR) USROPN                                CPK019
 
     FSMDPGMPD  O    E             DISK    INFSR(*PSSR)
     FSMMIGIPD  O    E             DISK    INFSR(*PSSR)                                       CPK019
     FSM1080P1  O    E             PRINTER INFSR(*PSSR)
     FSM1080P2  O    E             PRINTER INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Arrays containing installed Midas modules information and Shortnames from SDMMIDPD
     D @Mods           S              2    DIM(114)
     D @ShortNames     S             10    DIM(114)
      *
      ** SD Data Area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
     D  Prefix                 6      7
 
     D MGRPICDE        DS
     D  MGRP                   1      4S 0
     D  MGRPA                  1      4
     D  ICDE                   5      8
 
     D Counter         DS
     D  NextNumber             1      8S 0 INZ(00000001)
     D  NextNumberA            1      8
 
     D MitemACList     DS
     D  AAC1                   1      1
     D  AAC2                   2      2
     D  AAC3                   3      3
     D  AAC4                   4      4
     D  AAC5                   5      5
     D  AAC6                   6      6
     D  AAC7                   7      7
     D  AAC8                   8      8
     D  AAC9                   9      9
     D  AAC10                 10     10
      *
     D ConvActList     DS
     D  XXAAC1                 1      1
     D  XXAAC2                 2      2
     D  XXAAC3                 3      3
     D  XXAAC4                 4      4
     D  XXAAC5                 5      5
     D  XXAAC6                 6      6
     D  XXAAC7                 7      7
     D  XXAAC8                 8      8
     D  XXAAC9                 9      9
     D  XXAAC10               10     10
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D @Idx            S              3S 0
     D LineCount       S              2S 0                                      for SM1080P1
     D LineCountAC     S              2S 0                                      for SM1080P2
     D KPCMD           S                   LIKE(PCMD)                           PCMD in CmdGrpKey
     D KPARA           S                   LIKE(PARA)                           PARA in CmdGrpKey
     D KMGRP           S                   LIKE(MGRP)                           MGRP in CmdGrpKey
     D KICDE           S                   LIKE(ICDE)                           ICDE in CmdGrpKey
     D SavePCMD        S                   LIKE(PCMD)                           Saved PCMD
     D SavePARA        S                   LIKE(PARA)                           Saved PARA
     D SaveMGRP        S                   LIKE(MGRP)                           Saved MGRP
     D SaveICDE        S                   LIKE(ICDE)                           Saved ICDE
     D LastPCMD        S                   LIKE(PCMD)                           Last PCMD processed
     D LastPARA        S                   LIKE(PARA)                           Last PARA processed
     D NextRecFound    S              1                                         Y=next valid rec fnd
     D IgnoredCmd      S              1                                         Cmd ignored in corv
 
      * Rename field with the same name in SMITEML0.
     IITEML0F
     I              MIACOB                      ACOB
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C                   EXSR      ChkItemsByGrp
      *
     C                   EXSR      ChkItemsByCmd
      *
      * Close the output files for migration if passed in parameter P0Update = '*YES'.        CPK019
     C                   IF        P0Update = '*YES'                                          CPK019
     C                   CLOSE     SFMENUPD                                                   CPK019
     C                   CLOSE     GPMTXTPD                                                   CPK019
     C                   CLOSE     SMSFCVPD                                                   CPK019
     C                   CLOSE     SCSARIPD                                                   CPK019
     C                   ENDIF                                                                CPK019
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkItemsByGrp - Read in SMITEMPD (by MGRP, ICDE unqiue). Print*
      *                 items to SM1080P1 for any different PCMD, PARA*
      *                 in the conversion file for the MGRP, ICDE.    *
      *                                                               *
      * Called by: Main Prcessing                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     ChkItemsByGrp BEGSR
      *
      * Set off 'record to report SM1080P1' indicator.
     C                   SETOFF                                       71
      * Set off 'Difference action codes to report' indicator
     C                   SETOFF                                       68
      *
      * Print heading for Differnce Menu Program and Parameters report (SM1080P1)
     C                   WRITE     HEAD1
     C                   EVAL      LineCount = 8
      *
      * Print heading for Differnce Action Codes report (SM1080P2)
     C                   WRITE     HEADAC
     C                   EVAL      LineCountAC = 8
      *
     C     *LOVAL        SETLL     SMITEMPD
      *
     C                   READ      SMITEMPD                               20
      *
     C                   DOW       *IN20 = '0'
      *
      * Process item if PCMD <> TITLE and MENU
     C                   IF        (PCMD <> 'TITLE') AND
     C                             (PCMD <> 'MENU')
      *
      * Check if module for the item exists in the array @Mods
     C     MODC          LOOKUP    @Mods(1)                               60
      *
      * If module exists, check if the item exists in conversion file
     C     *IN60         IFEQ      *ON
      *
     C     GrpKey        CHAIN     SMSFCVL0                           30
      *
      * If record found in conversion file,
     C                   IF        *IN30 = '0'
      *
      *    IF Unique code not = '**IGNORE**', compare the action codes allowed.
      *       Print out to SM1080P2 if different.
     C                   IF        XXINDX <> '**IGNORE**'
     C                   EXSR      CompareActCod
     C                   ENDIF
      *
      *    Output to SM1080P1 when the PCMD, PARA in conversion file are
      *    different from SMITEMPD
     C                   IF        (PCMD  <> XXPCMD) OR
     C                             (PARA  <> XXPARA)
     C                   WRITE     DTL1
     C                   SETON                                        71
     C                   ADD       3             LineCount
      *
      * If line printed exceeds 55, write header
     C                   IF        LineCount > 55
     C                   WRITE     HEAD1
     C                   Z-ADD     8             LineCount
     C                   ENDIF
      *
     C                   ENDIF                                                  FI PCMD <> XXPCMD or
      *                                                                            PARA <> XXPARA
      *
     C                   ENDIF                                                  FI *IN30 = '0'
      *
     C                   ENDIF                                                  FI *IN60 = *ON
      *
     C                   ENDIF                                                  FI PCMD <> 'TITLE'
      *                                                                         and <> 'MENU'
      *
     C                   READ      SMITEMPD                               20
     C                   ENDDO                                                  WO *IN20 = '0'
      *
      * If no items written to SM1080P1,  write 'no records' to SM1080P1.
     C     *IN71         IFEQ      *OFF
     C                   WRITE     NORECS1
     C                   ENDIF
      *
      * Write 'End of Report' to SM1080P1.
     C                   WRITE     TRAILP1
      *
      * If no items written to SM1080P2,  write 'no records' to SM1080P2.
     C     *IN68         IFEQ      *OFF
     C                   WRITE     NORECSAC
     C                   ENDIF
      *
      * Write 'End of Report' to SM1080P2.
     C                   WRITE     TRAILAC
      *
     C     ChkItemsByGrpEENDSR
      *
      *****************************************************************
      *                                                               *
      * CompareActCod - Compare action codes and report any           *
      *                 differences to SM1073P2.                      *
      *                                                               *
      * Called by: ChkItemsByGrp                                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     CompareActCod BEGSR
      *
     C                   IF        MitemACList <> ConvActList
      *
      * Print the difference only when the first action codes are not 'Z' and ' '.
     C                   IF        ((AAC1 = 'Z') AND (XXAAC1 = ' ')) OR
     C                             ((AAC1 = ' ') AND (XXAAC1 = 'Z'))
     C                   ELSE
     C                   WRITE     DTLAC
     C                   ADD       3             LineCountAC
     C                   SETON                                        68
      *
      * If line printed exceeds 55, write header
     C                   IF        LineCountAC > 55
     C                   WRITE     HEADAC
     C                   Z-ADD     8             LineCountAC
     C                   ENDIF                                                  FI LineCountAC > 55
      *
     C                   ENDIF                                                  FI
      *
     C                   ENDIF                                                  FI MitemACList <>
      *                                                                            ConvActList
      *
     C     CompareActCodEENDSR
      *
      *****************************************************************
      *                                                               *
      * ChkItemsByCmd - Read in SMITEML0 (by PCMD, PARA).             *
      *                 When dup. PCMD  PARA, write recs to SMDPGMPD. *
      *                 When the PCMD PARA and MGRP ICDE are new in   *
      *                 conversion file and the PCMD PARA is unique,  *
      *                 output records to SFMENUPD, SMSFCVPD and      *
      *                 GPMTXTPD.                                     *
      *                                                               *
      * Called by: Main Prcessing                                     *
      *                                                               *
      * Calls: ChkDuplicate                                           *
      *        ChkIgnored                                             *
      *        WrtDPGMD0                                              *
      *        ChkGrpInConv                                           *
      *                                                               *
      *****************************************************************
      *
     C     ChkItemsByCmd BEGSR
      *
      * Initialize variables.
     C                   EVAL      LastPCMD = *BLANK
     C                   EVAL      LastPARA = *BLANK
      *
     C     *LOVAL        SETLL     SMITEML0
      *
     C                   READ      SMITEML0                               20
      *
     C                   DOW       *IN20 = '0'
      *
      *
      * Check if module for the item exists in the array @Mods
     C     MODC          LOOKUP    @Mods                                  60
      *
      * If module exists,
     C     *IN60         IFEQ      *ON
      *
     C                   IF        (LastPCMD  <> PCMD) OR
     C                             (LastPARA  <> PARA)
      *
     C                   EXSR      ChkDuplicate
      *
     C                   ENDIF                                                  FI LastPCMD<>PCMD
      *                                                                         or LastPARA<>PARA
      * Check if record with same PCMD, PARA, MGRP, ICDE found in conversion file.
     C                   EVAL      KPCMD = PCMD
     C                   EVAL      KPARA = PARA
     C                   EVAL      KMGRP = MGRP
     C                   EVAL      KICDE = ICDE
     C     CmdGrpKey     SETLL     SMSFCVL2                               33    ON, match found
      *
      * If record matching PCMD, PARA, MGRP, ICDE found in conversion file,
     C                   IF        *IN33 = '1'
     C                   READ      SMSFCVL2
      *
      *    If duplicated PCMD, PARA in MITEMDD, output to SMDPGMPD.
     C                   IF        *IN45 = '1'
     C                   EVAL      MCMDPAR = 'Yes'
     C                   EVAL      MGRPCDE = 'Yes'
      *
     C                   IF        XXINDX  = '**IGNORE**'
     C                   EVAL      CMDIGN  = 'Yes'
     C                   ELSE
     C                   EVAL      CMDIGN  = 'No'
     C                   ENDIF                                                  FI XXINDX=**IGNORE**
      *
     C                   WRITE     SMDPGMD0
     C                   ENDIF                                                  FI *IN45 = '1'
      *
     C                   ELSE
      * ie, no record matching PCMD, PARA, MGRP, ICDE found,
      *     Check any records in conversion file match with PCMD and PARA only
      *
     C                   EVAL      KPCMD = PCMD
     C                   EVAL      KPARA = PARA
      * position to the beginning of records starting from PCMD, PARA
     C     CmdKey        SETLL     SMSFCVL2                               32    match PCMD, PARA
      *
     C                   IF        *IN32 = '1'
     C   45              EXSR      ChkIgnored                                   when duplicate
     C   45              EXSR      WrtDPGMD0                                    when duplicate
     C                   ELSE
      * PCMD, PARA not match in conversion file
     C                   EXSR      ChkGrpInConv
     C                   ENDIF                                                  FI *IN32 = '1'
      *                                                                         OR  LastPARA <> PARA
     C                   ENDIF                                                  FI *IN33 = '1'
      *
     C                   EVAL      LastPCMD   = PCMD
     C                   EVAL      LastPARA   = PARA
      *
     C                   ENDIF                                                  FI *IN60 = *ON
      *
     C                   READ      SMITEML0                               20
     C                   ENDDO                                                  WO *IN20 = '0'
      *
     C     ChkItemsByCmdEENDSR
      *****************************************************************
      *                                                               *
      * ChkDuplicate - check if there are more than 1 records with    *
      *                same PCMD, PARA values in SMITEML0, set on     *
      *                *IN45.                                         *
      *                                                               *
      * Called by: ChkItemsByCmd                                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     ChkDuplicate  BEGSR
      *
      * Initialize variables.
     C                   EVAL      *IN45 = '0'
     C                   EVAL      NextRecFound = 'N'
      *
     C                   EVAL      SavePCMD = PCMD
     C                   EVAL      SavePARA = PARA
     C                   EVAL      SaveMGRP = MGRP
     C                   EVAL      SaveICDE = ICDE
      *
     C                   READ      SMITEML0                               22    EOF
      *
     C                   DOW       (*IN22        = '0') AND
     C                             (NextRecFound = 'N')
     C
      * Check if module for the item exists in the array @Mods
     C     MODC          LOOKUP    @Mods(1)                               60
      *
      * If module exists, check if the record has same PCMD and PARA as last..
     C                   IF        *IN60        = '1'
     C                   EVAL      NextRecFound = 'Y'
     C                   IF        (SavePCMD    = PCMD) AND
     C                             (SavePARA    = PARA)
     C                   SETON                                        45        Duplicate PCMD PARA
     C                   END
      *
     C                   ELSE
     C                   READ      SMITEML0                               22    EOF
     C                   ENDIF                                                  FI *IN60 = '1'
      *
     C                   ENDDO
      *
      * Position/chain back to the record in SMITEML0 at the beginning of this SR.
     C                   EVAL      KPCMD = SavePCMD
     C                   EVAL      KPARA = SavePARA
     C                   EVAL      KMGRP = SaveMGRP
     C                   EVAL      KICDE = SaveICDE
     C     CmdGrpKey     CHAIN     SMITEML0
      *
     C     ChkDuplicateE ENDSR
      *
      *****************************************************************
      *                                                               *
      * ChkIgnored - Check if all conversion records with same        *
      *                  PCMD and PARA have been ignored.             *
      *              If all ignored, set IgnoredCmd field = 'Y'       *
      *              Else Set IgnoredCmd field = 'N'.                 *
      *                                                               *
      * Called by: ChkItemsByCmd                                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     ChkIgnored    BEGSR
      *
     C                   EVAL      IgnoredCmd   = 'Y'
      *
     C                   READ      SMSFCVL2
      *
     C                   DOW       (XXPCMD      = KPCMD) AND
     C                             (XXPARA      = KPARA) AND
     C                             (IgnoredCmd  = 'Y')   AND
     C                             (*IN35       = '0')
      *
     C                   IF        XXINDX      <> '**IGNORE**'
     C                   EVAL      IgnoredCmd  = 'N'
     C                   ELSE
     C                   READ      SMSFCVL2                               35    EoF
     C                   ENDIF                                                  FI XXINDX<>**IGNORE*
      *
     C                   ENDDO                                                  OD
      *
     C     ChkIgnoredE   ENDSR
      *
      *****************************************************************
      *                                                               *
      * WrtDPGMD0  - Output record to SMDPDMPD file for duplicate     *
      *              and match PCMD PARA, but group and item unmatched*
      *                                                               *
      * Called by: ChkItemsByCmd                                      *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
      *
     C     WrtDPGMD0     BEGSR
      *
     C                   EVAL      MCMDPAR = 'Yes'
     C                   EVAL      MGRPCDE = 'No '
      *
     C                   IF        IgnoredCmd = 'Y'
     C                   EVAL      CMDIGN  = 'Yes'
     C                   ELSE
      * ie, IgnoredCmd = 'N'
     C                   EVAL      CMDIGN  = 'No '
     C                   ENDIF                                                  FI *Ignored = 'Y'
      *
     C                   WRITE     SMDPGMD0
      *
     C     WrtDPGMD0E    ENDSR
      *
      *****************************************************************
      *                                                               *
      * ChkGrpInConv - Check if the MGRP ICDE for the unmatched PCMD  *
      *                PARA item exists in the conversion file.       *
      *                If not exist and unique PCMD PARA item,        *
      *                   - write a record to SMMIGIPD                *
      *                   - if P0Update = *YES, write records to      *
      *                     to SFMENUPD, GPMTXTPD, SMSFCVPD, SCSARIPD.*
      *                If not exist and duplicated PCMD PARA item,    *
      *                   output record to SMDPGMPD.                  *
      *                                                               *
      * Called by: ChkItemsByCmd                                      *
      *                                                               *
      * Calls:     WriteNewRecs                                       *
      *                                                               *
      *****************************************************************
      *
     C     ChkGrpInConv  BEGSR
      *
      *
     C     GrpKey        SETLL     SMSFCVL0                               31    Match MGRP ICDE fnd
      *
     C                   IF        *IN31 = '1'
      *
      * If duplicated PCMD PARA record in MITEMDD, write record to SMDPGMPD.
     C                   IF        *IN45 = '1'
     C                   EVAL      MCMDPAR = 'No '
     C                   EVAL      MGRPCDE = 'Yes'
     C                   EVAL      CMDIGN  = *BLANK
     C                   WRITE     SMDPGMD0
     C                   ENDIF                                                  FI  *IN45 = '1'
      *
     C                   ELSE
      * ie, no match MGRP ICDE record found in conversion file.
     C                   IF        *IN45 = '1'
     C                   EVAL      MCMDPAR = 'No '
     C                   EVAL      MGRPCDE = 'No '
     C                   EVAL      CMDIGN  = *BLANK
     C                   WRITE     SMDPGMD0
     C                   ELSE
      *
      * also if unique PCMD PARA record in MITEMDD.
     C                   EVAL      MIINDX = *BLANK                                            CPK019
      * If passed in parameter P0Update = '*YES', write records to files.                     CPK019
     C                   IF        P0Update = '*YES'                                          CPK019
     C                   EXSR      WrtNewRecs
     C                   ENDIF                                                                CPK019
      *
     C                   WRITE     SMMIGID0                                                   CPK019
     C                   ENDIF                                                  FI  *IN45 = '1'
      *
     C                   ENDIF                                                  FI  *IN31 = '1'
      *
     C     ChkGrpInConvE ENDSR
      *
      *****************************************************************
      *                                                               *
      * WrtNewRecs - Write new records to files SFMENUPD, GPMTXTPD,   *
      *              SMSFCVPD and SCSARIPD.                           *
      *                                                               *
      * Called by: ChkGrpInConv                                       *
      *                                                               *
      * Calls:     WrtSFRecs                                          *
      *                                                               *
      *****************************************************************
      *
     C     WrtNewRecs    BEGSR
      *
      * Set up data for and write SFMENUPD record.
     C                   EVAL      MIZONE  = *BLANK
     C                   EVAL      MIINDX  = Prefix + NextNumberA
     C                   EVAL      MISECL  = SECL
     C                   EVAL      MIMODC  = MODC
 
      * Get Modules Shortname from array @ShortNames:
      * Set up array index to search from 1
     C                   EVAL      @Idx    = 1
     C     MODC          LOOKUP    @Mods(@Idx)                            60    module codes found
     C   60              EVAL      MIMMSN  = @ShortNames(@Idx)
     C  N60              EVAL      MIMMSN  = *BLANK
      *
     C                   EVAL      MIEXTP  = 'A'
     C                   EVAL      MIFRAM  = 'menucontent'
     C                   EVAL      MIPATH  = PCMD + PARA
     C                   EVAL      MIAAC1  = AAC1
     C                   EVAL      MIAAC2  = AAC2
     C                   EVAL      MIAAC3  = AAC3
     C                   EVAL      MIAAC4  = AAC4
     C                   EVAL      MIAAC5  = AAC5
     C                   EVAL      MIAAC6  = AAC6
     C                   EVAL      MIAAC7  = AAC7
     C                   EVAL      MIAAC8  = AAC8
     C                   EVAL      MIAAC9  = AAC9
     C                   EVAL      MIAAC10 = AAC10
     C                   EVAL      MIACOB  = ACOB
     C                   EVAL      MIAPI1  = *BLANK
     C                   EVAL      MIAPI2  = *BLANK
     C                   EVAL      MIAPI3  = *BLANK
     C                   EVAL      MIAPI4  = *BLANK
     C                   EVAL      MIAPI5  = *BLANK
     C                   EVAL      MIINS   = 'CLIENT'
     C                   WRITE     SFMENUD0
      *
      * Set up data for and write GPMTXTPD record.
     C                   EVAL      MISNAM = MGRPICDE
     C                   EVAL      MIINAR = INAR
     C                   EVAL      MIDEL  = *BLANK
     C                   WRITE     GPMTXTD0
      *
      * Set up data for and write SMSFCVPD record.
     C                   EVAL      XXMGRP = MGRP
     C                   EVAL      XXICDE = ICDE
     C                   EVAL      XXINDX = MIINDX
     C                   EVAL      XXINAR = INAR
     C                   EVAL      XXPCMD = PCMD
     C                   EVAL      XXPARA = PARA
     C                   EVAL      XXAAC1 = AAC1
     C                   EVAL      XXAAC2 = AAC2
     C                   EVAL      XXAAC3 = AAC3
     C                   EVAL      XXAAC4 = AAC4
     C                   EVAL      XXAAC5 = AAC5
     C                   EVAL      XXAAC6 = AAC6
     C                   EVAL      XXAAC7 = AAC7
     C                   EVAL      XXAAC8 = AAC8
     C                   EVAL      XXAAC9 = AAC9
     C                   EVAL      XXAAC10 = AAC10
     C                   WRITE     SMSFCVD0
      *
      * Write records to SCSARIPD.
     C                   EXSR      WrtSFRecs
      *
     C                   EVAL      NextNumber = NextNumber + 1
      *
     C     WrtNewRecsE   ENDSR
      *
      *****************************************************************
      *                                                               *
      * WrtSFRecs  - Copy records with same MGRP and ICDE from        *
      ***************UPSARIL1*to*SCSARIPD.*****************************                     AR936709
      *              SMSARIPD to SCSARIPD.                            *                     AR936709
      *                                                               *
      * Called by: WrtNewRecs                                         *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
      *
     C     WrtSFRecs     BEGSR
      *
     C*****SARIKey       CHAIN     UPSARIL1                           29        Rec not fou AR936709
     C     SARIKey       CHAIN     SMSARIPD                           29                    AR936709
      *
      **Copy*to*SCSARIPD*if*records*with*same*MGRP*and*ICDE*found*in*UPSARIL1*              AR936709
      * Copy to SCSARIPD if records with same MGRP and ICDE found in SMSARIPD.              AR936709
     C                   DOW       *IN29   = '0'
      *
     C                   EVAL      ADINDX  = MIINDX
     C                   EVAL      ADZONE  = *BLANK
     C                   WRITE     SCSARID0
      *
     C*****SARIKey       READE     UPSARIL1                               29    not match   AR936709
     C     SARIKey       READE     SMSARIPD                               29                AR936709
     C                   ENDDO                                                  ODW *IN29 = '0'
      *
     C     WrtSFRecsE    ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: LoadModSName                                           *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      * Entry parameters                                                                      CPK019
     C     *ENTRY        PLIST                                                                CPK019
     C                   PARM                    P0Update          4            Update option CPK019
      *
     C     Grpkey        KLIST
     C                   KFLD                    MGRP
     C                   KFLD                    ICDE
      *
     C     CmdGrpKey     KLIST
     C                   KFLD                    KPCMD
     C                   KFLD                    KPARA
     C                   KFLD                    KMGRP
     C                   KFLD                    KICDE
      *
     C     CmdKey        KLIST
     C                   KFLD                    KPCMD
     C                   KFLD                    KPARA
      *
     C     SARIKey       KLIST
     C                   KFLD                    MGRPA
     C                   KFLD                    ICDE
      *
      * Access SDSTAT to get the system prefix
      *
     C                   IN        SDSTAT
      *
      * Set up @Mods and @ShortNames arrays from installed Midas Modules Information file
     C                   EXSR      LoadModSName
      *
      * Open the output files for migration if passed in parameter P0Update = '*YES'.         CPK019
     C                   IF        P0Update = '*YES'                                          CPK019
     C                   OPEN      SFMENUPD                                                   CPK019
     C                   OPEN      GPMTXTPD                                                   CPK019
     C                   OPEN      SMSFCVPD                                                   CPK019
     C                   OPEN      SCSARIPD                                                   CPK019
     C                   ENDIF                                                                CPK019
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * LoadModSName - Load @Mods and @ShortNames arrays from         *
      *                Installed Midas Modules Information file       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     LoadModSName  BEGSR
      *
     C                   EVAL      @Idx    =  0
      *
     C                   READ      SDMMIDL2                               10
      *
     C                   DOW       (*IN10 = '0') AND
     C                             (@Idx  < 114)
      *
     C                   EVAL      @Idx              = @Idx    + 1
     C                   EVAL      @Mods(@Idx)       = FOSPFM
     C                   EVAL      @ShortNames(@Idx) = FOMMSN
      *
     C                   READ      SDMMIDL2                               10
      *
     C                   ENDDO
      *
     C     LoadModSNameE ENDSR
      *
      *
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
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
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
      *****************************************************************
