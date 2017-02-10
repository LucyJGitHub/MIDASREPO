/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*O*R****OVRDBF YLOANCY0 TOFILE(ULINTFLIB/CLOANCY0)                   *                       LUC109
/*O*RF***OVRDBF YEALSCY0 TOFILE(ULINTFLIB/DEALSCY0)                   *                       LUC109
/*O*RF***OVRDBF YEALSDY0 TOFILE(ULINTFLIB/DEALSDY0)                   *                       LUC109
/*O*RF***OVRDBF YCCNTBX0 TOFILE(ULINTFLIB/ACCNTBX0)                   *                       LUC109
/*O*RF***OVRDBF YCCNTBY2 TOFILE(ULINTFLIB/ACCNTBY2)                   *                       LUC109
/*OVR****OVRDBF YLOANCY0 TOFILE(LSINTFLIB/CLOANCY0)                   *                       LUC109
/*OVRF***OVRDBF YEALSCY0 TOFILE(LSINTFLIB/DEALSCY0)                   *                       LUC109
/*OVRF***OVRDBF YEALSDY0 TOFILE(LSINTFLIB/DEALSDY0)                   *                       LUC109
/*OVRF***OVRDBF YCCNTBX0 TOFILE(LSINTFLIB/ACCNTBX0)                   *                       LUC109
/*OVRF***OVRDBF YCCNTBY2 TOFILE(LSINTFLIB/ACCNTBY2)                   *                       LUC109
/*OVRF*: OVRDBF XCCNTBX0 ACCNTBX0                                     *
/*OVRF*: OVRDBF XLOANCX0 CLOANCX0                                     *
/*OVRF*: OVRDBF XEALSCX0 DEALSCX0                                     *
/*OVRF*: OVRDBF XEALSDX0 DEALSDX0                                     *
/*EXI *  TEXT('Copy HOF Extension File records')                      *                       LUC109
      *****************************************************************
     H DEBUG
      *****************************************************************
      *                                                               *
      *  Midas - Midas Head Office Interface                          *
      *                                                               *
      ***GLM056A*-*Copy*HOF*Extension*File*records*********************                       LUC109
      *  XX00056A - Copy HOF Extension File records                   *                       LUC109
      *  (Copy of IBCM021 - CAR ICM003)                               *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*International*LTD*1998**********************                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 25Jan17               *
      *  Prev Amend No. LUC109             Date 21Sep16               *
      *                 LUC013             Date 15Mar08               *
      *                 MUI011             Date 15Jul04               *
      *                 MUI009             Date 16Feb04               *
      *                 187153             Date 04Dec00               *
      *                 168004             Date 10Nov99               *
      *                 159964             Date 22Aug99               *
      *                 MMI043 *CREATE     Date 23Apr99               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109  -R306 Netting flag not available in Loans            *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  LUC013 - Move first 4 characters of AACOD to MACOD.          *
      *  MUI011 - ALMS changes to HOR - add ISIN code to CLOANCX0.    *
      *  MUI009 - R4.1 Upgrade:                                       *
      *           Added I specs requireds by ZCBDYS                   *
      *           Added ZDATE9 which is now required by ZCBDYS        *
      *           Added ZDATE10 which is now required by ZCBDYS       *
      *  187153 - Include Monthly Average fields from ACCNTBX0,       *
      *           CLOANCX0, DEALSCX0, DEALSDX0.                       *
      *  168004 - Update LF/YEALSCY0 if field CSUAM changes           *
      *         - File overrides added to creation parms              *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Bank of Italy Head Office Reporting                 *
      *           Extract only new records from the extension files   *
      *                                                               *
      *****************************************************************
     FYCCNTBY2  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FYLOANCY0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FYEALSCY0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FYEALSDY0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FXCCNTBX0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNBFX0:XCCNBFX0)
     FXLOANCX0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANFX0:XLOANFX0)
     FXEALSCX0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALCFX0:XEALCFX0)
     FXEALSDX0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALDFX0:XEALDFX0)
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     F***GLM056AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000056AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      * 01 - READ PF/XCCNTBX0                                         *
      * 02 - READ PF/XLOANCX0                                         *
      * 03 - READ PF/XEALSCX0                                         *
      * 04 - READ PF/XEALSDX0                                         *
      * 05 - General CHAIN indicator                                  *
      * LR - End of program                                           *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *   SRINIT - First cycle                                        *
      *   SRACCT - ACCNTBX0 extract                                   *
      *   SRLOAN - CLOANCX0 extract                                   *
      *   SRDELC - DEALSCX0 extract                                   *
      *   SRDELD - DEALSDX0 extract                                   *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      ** Local Data Area for Database Error Details
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      ***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
      /COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
     I***/C*PY*ZSRSRC,ZDATE9Z1                                                         MUI009 LUC109
      /COPY ZSRSRC,ZDATE9Z1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDAYSZ1                                                                 LUC109
      /COPY ZSRSRC,ZDAYSZ1LE                                                                  LUC109
      *                                                                                       LUC109
      ** Data structure for subroutine ZCBDYS                                                 LUC109
     D                 DS                                                                     LUC109
     D  ZZDAT1                 1      8  0                                                    LUC109
     D  ZZYYA                  1      4  0                                                    LUC109
     D  ZZMMA                  5      6  0                                                    LUC109
     D  ZZDDA                  7      8  0                                                    LUC109
      *                                                                                       LUC109
     D                 DS                                                                     LUC109
     D  ZZDAT2                 1      8  0                                                    LUC109
     D  ZZYYB                  1      4  0                                                    LUC109
     D  ZZMMB                  5      6  0                                                    LUC109
     D  ZZDDB                  7      8  0                                                    LUC109
      *                                                                                       LUC109
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 LUC109
     D/COPY ZSRSRC,ZDAT10Z1LE                                                                 LUC109
     I/EJECT                                                                                  LUC109
     IXCCNBFX0
      *
      ** Rename ACCNBFX0 Format fields - XCCNTBX0 file
      *
     I              MCNUM                       ACNUM
     I              MCCY                        ACCY
     I              MACOD                       AACOD
     I              MACSQ                       AACSQ
     I              MBRCA                       ABRCA
     I              MDAVX                       ADAVX
     I              MDAVR                       ADAVR
     I              MCRPX                       ACRPX
     I              MCRPO                       ACRPO
     I              MCAVX                       ACAVX
     I              MCAVR                       ACAVR
     I              MCPPV                       ACPPV
     I              MCPDM                       ACPDM
     I              MDPPV                       ADPPV
     I              MDPDM                       ADPDM
     I              MDCPV                       ADCPV
     I              MNDPX                       ANDPX
     I              MNDPO                       ANDPO
     I              MDCMM                       ADCMM
     I              MDGPV                       ADGPV
     I              MDCGM                       ADCGM
     I              MDALX                       ADALX
     I              MDALB                       ADALB
     I              MCALX                       ACALX
     I              MCALB                       ACALB
     I              MNCPX                       ANCPX
     I              MNCPO                       ANCPO
     I              MDACX                       ADACX
     I              MDACB                       ADACB
     I              MCACX                       ACACX
     I              MCACB                       ACACB
     I              MQXAB                       AQXAB
     I              MQMAV                       AQMAV
     I              MQXAV                       AQXAV
     I              MMTDY                       AMTDY
     I              MPQMA                       APQMA
     I              MQDIX                       AQDIX
     I              MQDIM                       AQDIM
     I              MQCIX                       AQCIX
     I              MQCIM                       AQCIM
     I              MNOCX                       ANOCX
     I              MNOCQ                       ANOCQ
     I              MAMCX                       AAMCX
     I              MAMCQ                       AAMCQ
     I              MUNPD                       AUNPD
     I              MRVNO                       ARVNO
     I              MDRPX                       ADRPX
     I              MDRPO                       ADRPO
     I              MCDIRX                      ACDIRX
     I              MCCIRX                      ACCIRX
     I              MLDBLX                      ALDBLX
     I              MCLBLX                      ACLBLX
     IXLOANFX0
      *
      ** Rename CLOANFX0 Format fields - XLOANCX0 file
      *
     I              MLNRF                       LLNRF
     I              MCRTP                       LCRTP
     I              MCONS                       LCONS
     I              MCSLD                       LCSLD
     I              MGCUS                       LGCUS
     I              MUNTR                       LUNTR
     I              MBCTY                       LBCTY
     I              MDISC                       LDISC
     I              MDCUS                       LDCUS
     I              MDCTY                       LDCTY
     I              MBILL                       LBILL
     I              MDAVX                       LDAVX
     I              MDAVR                       LDAVR
     I              MDAPV                       LDAPV
     I              MDACM                       LDACM
     I              MDALX                       LDALX
     I              MDALB                       LDALB
     I              MDACX                       LDACX
     I              MDACB                       LDACB
     I              MTOTI                       LTOTI
     I              MQDIX                       LQDIX
     I              MQDIM                       LQDIM
     I              MQXAB                       LQXAB
     I              MQMAV                       LQMAV
     I              MQXAV                       LQXAV
     I              MPQMA                       LPQMA
     I              MPQXA                       LPQXA
     I              MDCPV                       LDCPV
     I              MDCMM                       LDCMM
     I              MDGPV                       LDGPV
     I              MDCGM                       LDCGM
     I              MMTDY                       LMTDY
     I              MCPAMX                      LCPAMX
     I              MINTRX                      LINTRX
     I              MACPQ                       LACPQ
     I              MNCPQ                       LNCPQ
     I              MISIN                       LISIN                           MUI011
     IXEALCFX0
      *
      ** Rename DEALCFX0 Format fields - XEALSCX0 file
      *
     I              MDLNO                       CDLNO
     I              MPCT                        CPCT
     I              MSUAM                       CSUAM
     I              MDAVX                       CDAVX
     I              MDAVR                       CDAVR
     I              MCAVX                       CCAVX
     I              MCAVR                       CCAVR
     I              MCAPV                       CCAPV
     I              MCACM                       CCACM
     I              MDAPV                       CDAPV
     I              MDACM                       CDACM
     I              MDALX                       CDALX
     I              MDALB                       CDALB
     I              MCALX                       CCALX
     I              MCALB                       CCALB
     I              MDACX                       CDACX
     I              MDACB                       CDACB
     I              MCACX                       CCACX
     I              MCACB                       CCACB
     I              MTOTI                       CTOTI
     I              MQDIX                       CQDIX
     I              MQDIM                       CQDIM
     I              MQCIX                       CQCIX
     I              MQCIM                       CQCIM
     I              MMTDY                       CMTDY
     I              MPCPLX                      CPCPLX
     I              MINTRX                      CINTRX
     I              MDRCRX                      CDRCRX
     I              MXTRNO                      CXTRNO                               LUC109
     I              MSCCY                       CSCCY                                LUC109
     I              MXCNTL                      CXCNTL                               LUC109
     IXEALDFX0
      *
      ** Rename DEALDFX0 Format fields - XEALSDX0 file
      *
     I              MDLNO                       DDLNO
     I              MDAVX                       DDAVX
     I              MDAVR                       DDAVR
     I              MCAVX                       DCAVX
     I              MCAVR                       DCAVR
     I              MCAPV                       DCAPV
     I              MCACM                       DCACM
     I              MDAPV                       DDAPV
     I              MDACM                       DDACM
     I              MDALX                       DDALX
     I              MDALB                       DDALB
     I              MCALX                       DCALX
     I              MCALB                       DCALB
     I              MDACX                       DDACX
     I              MDACB                       DDACB
     I              MCACX                       DCACX
     I              MCACB                       DCACB
     I              MTOTI                       DTOTI
     I              MQDIX                       DQDIX
     I              MQDIM                       DQDIM
     I              MQCIX                       DQCIX
     I              MQCIM                       DQCIM
     I              MMTDY                       DMTDY
     I              MFVALX                      DFVALX
     I              MINTRX                      DINTRX
     I              MDRCRX                      DDRCRX
     I              MXTRNO                      DXTRNO                               LUC109
     I              MXCNTL                      DXCNTL                               LUC109
      *                                                                   MUI009
     I***/C*PY*ZSRSRC,ZCBDYSZ2                                                         MUI009 LUC109
     I***/C*PY*ZSRSRC,ZDATE9Z2                                                         MUI009 LUC109
     I***/C*PY*ZSRSRC,ZDAT10Z1                                                                LUC109
      *===================================================================
     C/EJECT
      *===================================================================
      ** P R O G R A M     S T A R T
      *===================================================================
      *
      ** First Cycle Processing
      *
     C                   MOVEA     CPY@          BIS@             80
      *
     C                   EXSR      SRINIT
      *
      ** Main processing
      *
     C                   EXSR      SRACCT
     C                   EXSR      SRLOAN
     C                   EXSR      SRDELC
     C                   EXSR      SRDELD
      *
     C                   EXSR      SRTERM
      *
      *===================================================================
      ** P R O G R A M     E N D
      *===================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SR/SRINIT subroutine to execute first cycle.                 *
      *                                                               *
      *  Called by: S T A R T                                         *
      *  Calls    : *PSSR                                             *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR                                                  **SRINIT BEGSR**
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Initialise LDA Variables
      *
     C     *LOCK         IN        LDA
     C**********         MOVE      'GLM056A '    DBPGM                                        LUC109
     C                   MOVE      'XX00056A '   DBPGM                                        LUC109
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
      *
      ** Initial housekeeping
      *
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   MOVE      *OFF          *IN05
      *
     C                   READ      SDBANKPD                               05
      *
     C     *IN05         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '001'         DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERR  001 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      *OFF          *IN98
     C                   ELSE
     C                   MOVE      *ON           *IN98
     C                   END
      *
      ** Set-up key for ACCNTBY2
      *
     C     KKEY          KLIST
     C***********        KFLD                    ACNUM                                   LUC109
     C                   KFLD                    WCNUM             6 0                   LUC109
     C                   KFLD                    ACCY
     C*****                KFLD           AACOD                                          LUC013
     C                   KFLD                    WACOD
     C                   KFLD                    AACSQ
     C                   KFLD                    ABRCA
      *
     C                   ENDSR                                                  **SRINIT ENDSR**
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SR/SRACCT subroutine to extract new records to LF/ACCNTBY2   *
      *                                                               *
      *  Called by: S T A R T                                         *
      *                                                               *
      *****************************************************************
     C     SRACCT        BEGSR                                                  **SRACCT BEGSR**
      *
     C                   OPEN      YCCNTBY2
     C                   READ      XCCNTBX0                               01
     C                   MOVEL     AACOD         WACOD
     C                   MOVE      ACNUM         WCNUM                              LUC109
     C     *IN01         DOWEQ     '0'
     C     KKEY          CHAIN     YCCNTBY2                           05
     C     *IN05         IFEQ      '1'
     C**********         Z-ADD     ACNUM         MCNUM                              LUC109
     C                   MOVE      ACNUM         MCNUM                              LUC109
     C                   MOVE      ACCY          MCCY
     C*****                Z-ADDAACOD     MACOD                                          LUC013
     C                   MOVEL     AACOD         WACOD             4 0
     C                   Z-ADD     WACOD         MACOD
     C                   Z-ADD     AACSQ         MACSQ
     C                   MOVE      ABRCA         MBRCA
     C                   Z-ADD     ADAVX         MDAVX
     C                   Z-ADD     ADAVR         MDAVR
     C                   Z-ADD     ACRPX         MCRPX
     C                   Z-ADD     ACRPO         MCRPO
     C                   Z-ADD     ACAVX         MCAVX
     C                   Z-ADD     ACAVR         MCAVR
     C                   Z-ADD     ACPPV         MCPPV
     C                   Z-ADD     ACPDM         MCPDM
     C                   Z-ADD     ADPPV         MDPPV
     C                   Z-ADD     ADPDM         MDPDM
     C                   Z-ADD     ADCPV         MDCPV
     C                   Z-ADD     ANDPX         MNDPX
     C                   Z-ADD     ANDPO         MNDPO
     C                   Z-ADD     ADCMM         MDCMM
     C                   Z-ADD     ADGPV         MDGPV
     C                   Z-ADD     ADCGM         MDCGM
     C                   Z-ADD     ADALX         MDALX
     C                   Z-ADD     ADALB         MDALB
     C                   Z-ADD     ACALX         MCALX
     C                   Z-ADD     ACALB         MCALB
     C                   Z-ADD     ANCPX         MNCPX
     C                   Z-ADD     ANCPO         MNCPO
     C                   Z-ADD     ADACX         MDACX
     C                   Z-ADD     ADACB         MDACB
     C                   Z-ADD     ACACX         MCACX
     C                   Z-ADD     ACACB         MCACB
     C                   Z-ADD     AQXAB         MQXAB
     C                   Z-ADD     AQMAV         MQMAV
     C                   Z-ADD     AQXAV         MQXAV
     C                   Z-ADD     AMTDY         MMTDY
     C                   Z-ADD     APQMA         MPQMA
     C                   Z-ADD     AQDIX         MQDIX
     C                   Z-ADD     AQDIM         MQDIM
     C                   Z-ADD     AQCIX         MQCIX
     C                   Z-ADD     AQCIM         MQCIM
     C                   Z-ADD     ANOCX         MNOCX
     C                   Z-ADD     ANOCQ         MNOCQ
     C                   Z-ADD     AAMCX         MAMCX
     C                   Z-ADD     AAMCQ         MAMCQ
     C                   Z-ADD     AUNPD         MUNPD
     C                   Z-ADD     ARVNO         MRVNO
     C                   Z-ADD     ADRPX         MDRPX
     C                   Z-ADD     ADRPO         MDRPO
     C                   Z-ADD     ACDIRX        MCDIRX
     C                   Z-ADD     ACCIRX        MCCIRX
     C                   Z-ADD     ALDBLX        MLDBLX
     C                   Z-ADD     ACLBLX        MCLBLX
     C                   WRITE     ACCNBFX0
     C                   END
     C                   READ      XCCNTBX0                               01
     C                   MOVEL     AACOD         WACOD
     C                   MOVE      ACNUM         WCNUM                                  LUC109
     C                   END
     C                   CLOSE     YCCNTBY2
      *
     C                   ENDSR                                                  **SRACCT ENDSR**
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SR/SRLOAN subroutine to extract new records to LF/CLOANCY0   *
      *                                                               *
      *  Called by: S T A R T                                         *
      *                                                               *
      *****************************************************************
     C     SRLOAN        BEGSR                                                  **SRLOAN BEGSR**
      *
     C                   OPEN      YLOANCY0
     C                   READ      XLOANCX0                               02
     C                   MOVE      LLNRF         WLNRF             6 0              LUC109
     C     *IN02         DOWEQ     '0'
     C     LLNRF         CHAIN     YLOANCY0                           05
     C     *IN05         IFEQ      '1'
     C**********         Z-ADD     LLNRF         MLNRF                              LUC109
     C                   MOVE      LLNRF         MLNRF                              LUC109
     C                   MOVE      LCRTP         MCRTP
     C                   MOVE      LCONS         MCONS
     C                   MOVE      LCSLD         MCSLD
     C                   MOVE      LGCUS         MGCUS
     C                   MOVE      LUNTR         MUNTR
     C                   MOVE      LBCTY         MBCTY
     C                   MOVE      LDISC         MDISC
     C                   MOVE      LDCUS         MDCUS
     C                   MOVE      LDCTY         MDCTY
     C                   MOVE      LBILL         MBILL
     C                   Z-ADD     LDAVX         MDAVX
     C                   Z-ADD     LDAVR         MDAVR
     C                   Z-ADD     LDAPV         MDAPV
     C                   Z-ADD     LDACM         MDACM
     C                   Z-ADD     LDALX         MDALX
     C                   Z-ADD     LDALB         MDALB
     C                   Z-ADD     LDACX         MDACX
     C                   Z-ADD     LDACB         MDACB
     C                   Z-ADD     LTOTI         MTOTI
     C                   Z-ADD     LQDIX         MQDIX
     C                   Z-ADD     LQDIM         MQDIM
     C                   Z-ADD     LQXAB         MQXAB
     C                   Z-ADD     LQMAV         MQMAV
     C                   Z-ADD     LQXAV         MQXAV
     C                   Z-ADD     LPQMA         MPQMA
     C                   Z-ADD     LPQXA         MPQXA
     C                   Z-ADD     LDCPV         MDCPV
     C                   Z-ADD     LDCMM         MDCMM
     C                   Z-ADD     LDGPV         MDGPV
     C                   Z-ADD     LDCGM         MDCGM
     C                   Z-ADD     LMTDY         MMTDY
     C                   Z-ADD     LCPAMX        MCPAMX
     C                   Z-ADD     LINTRX        MINTRX
     C                   Z-ADD     LACPQ         MACPQ
     C                   Z-ADD     LNCPQ         MNCPQ
     C                   MOVE      LISIN         MISIN                                         MUI01
     C                   WRITE     CLOANFX0
     C                   ELSE
     C     MCRTP         IFNE      LCRTP
     C     MCONS         ORNE      LCONS
     C     MCSLD         ORNE      LCSLD
     C     MGCUS         ORNE      LGCUS
     C     MUNTR         ORNE      LUNTR
     C     MBCTY         ORNE      LBCTY
     C     MDISC         ORNE      LDISC
     C     MDCUS         ORNE      LDCUS
     C     MDCTY         ORNE      LDCTY
     C     MBILL         ORNE      LBILL
     C     MISIN         ORNE      LISIN                                                       MUI01
     C                   MOVE      LCRTP         MCRTP
     C                   MOVE      LCONS         MCONS
     C                   MOVE      LCSLD         MCSLD
     C                   MOVE      LGCUS         MGCUS
     C                   MOVE      LUNTR         MUNTR
     C                   MOVE      LBCTY         MBCTY
     C                   MOVE      LDISC         MDISC
     C                   MOVE      LDCUS         MDCUS
     C                   MOVE      LDCTY         MDCTY
     C                   MOVE      LBILL         MBILL
     C                   MOVE      LISIN         MISIN                                         MUI01
     C                   UPDATE    CLOANFX0
     C                   ENDIF
     C                   END
     C                   READ      XLOANCX0                               02
     C                   MOVE      LLNRF         WLNRF                              LUC109
     C                   END
     C                   CLOSE     YLOANCY0
      *
     C                   ENDSR                                                  **SRLOAN ENDSR**
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SR/SRDELC subroutine to extract new records to LF/DEALSCY0   *
      *                                                               *
      *  Called by: S T A R T                                         *
      *                                                               *
      *****************************************************************
     C     SRDELC        BEGSR                                                  **SRDELC BEGSR**
      *
     C                   OPEN      YEALSCY0
     C                   READ      XEALSCX0                               03
     C     *IN03         DOWEQ     '0'
     C     CDLNO         CHAIN     YEALSCY0                           05
     C     *IN05         IFEQ      '1'
     C                   Z-ADD     CDLNO         MDLNO
     C                   MOVE      CPCT          MPCT
     C                   Z-ADD     CSUAM         MSUAM
     C                   Z-ADD     CDAVX         MDAVX
     C                   Z-ADD     CDAVR         MDAVR
     C                   Z-ADD     CCAVX         MCAVX
     C                   Z-ADD     CCAVR         MCAVR
     C                   Z-ADD     CCAPV         MCAPV
     C                   Z-ADD     CCACM         MCACM
     C                   Z-ADD     CDAPV         MDAPV
     C                   Z-ADD     CDACM         MDACM
     C                   Z-ADD     CDALX         MDALX
     C                   Z-ADD     CDALB         MDALB
     C                   Z-ADD     CCALX         MCALX
     C                   Z-ADD     CCALB         MCALB
     C                   Z-ADD     CDACX         MDACX
     C                   Z-ADD     CDACB         MDACB
     C                   Z-ADD     CCACX         MCACX
     C                   Z-ADD     CCACB         MCACB
     C                   Z-ADD     CTOTI         MTOTI
     C                   Z-ADD     CQDIX         MQDIX
     C                   Z-ADD     CQDIM         MQDIM
     C                   Z-ADD     CQCIX         MQCIX
     C                   Z-ADD     CQCIM         MQCIM
     C                   Z-ADD     CMTDY         MMTDY
     C                   Z-ADD     CPCPLX        MPCPLX
     C                   Z-ADD     CINTRX        MINTRX
     C                   Z-ADD     CDRCRX        MDRCRX
     C                   MOVE      CXTRNO        MXTRNO                         LUC109
     C                   MOVE      CSCCY         MSCCY                          LUC109
     C                   MOVE      CXCNTL        MXCNTL                         LUC109
     C                   WRITE     DEALCFX0
     C                   ELSE                                                                 16800
     C     CSUAM         IFNE      MSUAM                                                      16800
     C     CPCT          ORNE      MPCT                                                       16800
     C     CXTRNO        ORNE      MXTRNO                                       LUC109
     C     CSCCY         ORNE      MSCCY                                        LUC109
     C     CXCNTL        ORNE      MXCNTL                                       LUC109
     C                   Z-ADD     CSUAM         MSUAM                                        16800
     C                   MOVE      CPCT          MPCT                                         16800
     C                   MOVE      CXTRNO        MXTRNO                         LUC109
     C                   MOVE      CSCCY         MSCCY                          LUC109
     C                   MOVE      CXCNTL        MXCNTL                         LUC109
     C                   UPDATE    DEALCFX0                                                    16800
     C                   END                                                                   16800
     C                   END
     C                   READ      XEALSCX0                               03
     C                   END
     C                   CLOSE     YEALSCY0
      *
     C                   ENDSR                                                  **SRDELC ENDSR**
      *****************************************************************
      *                                                               *
      *  SR/SRDELD subroutine to extract neL records to LF/DEALSDY0   *
      *                                                               *
      *  Called by: S T A R T                                         *
      *                                                               *
      *****************************************************************
     C     SRDELD        BEGSR                                                  **SRDELD BEGSR**
      *
     C                   OPEN      YEALSDY0
     C                   READ      XEALSDX0                               04
     C     *IN04         DOWEQ     '0'
     C     DDLNO         CHAIN     YEALSDY0                           05
     C     *IN05         IFEQ      '1'
     C                   Z-ADD     DDLNO         MDLNO
     C                   Z-ADD     DDAVX         MDAVX
     C                   Z-ADD     DDAVR         MDAVR
     C                   Z-ADD     DCAVX         MCAVX
     C                   Z-ADD     DCAVR         MCAVR
     C                   Z-ADD     DCAPV         MCAPV
     C                   Z-ADD     DCACM         MCACM
     C                   Z-ADD     DDAPV         MDAPV
     C                   Z-ADD     DDACM         MDACM
     C                   Z-ADD     DDALX         MDALX
     C                   Z-ADD     DDALB         MDALB
     C                   Z-ADD     DCALX         MCALX
     C                   Z-ADD     DCALB         MCALB
     C                   Z-ADD     DDACX         MDACX
     C                   Z-ADD     DDACB         MDACB
     C                   Z-ADD     DCACX         MCACX
     C                   Z-ADD     DCACB         MCACB
     C                   Z-ADD     DTOTI         MTOTI
     C                   Z-ADD     DQDIX         MQDIX
     C                   Z-ADD     DQDIM         MQDIM
     C                   Z-ADD     DQCIX         MQCIX
     C                   Z-ADD     DQCIM         MQCIM
     C                   Z-ADD     DMTDY         MMTDY
     C                   Z-ADD     DFVALX        MFVALX
     C                   Z-ADD     DINTRX        MINTRX
     C                   Z-ADD     DDRCRX        MDRCRX
     C                   MOVE      DXTRNO        MXTRNO                         LUC109
     C                   MOVE      DXCNTL        MXCNTL                         LUC109
     C                   WRITE     DEALDFX0
     C                   ELSE                                                   LUC109
     C     DXTRNO        IFNE      MXTRNO                                       LUC109
     C     DXCNTL        orne      MXCNTL                                       LUC109
     C                   MOVE      DXTRNO        DXTRNO                         LUC109
     C                   MOVE      DXCNTL        DXCNTL                         LUC109
     C                   UPDATE    DEALDFX0                                     LUC109
     C                   ENDIF                                                  LUC109
     C                   END
     C                   READ      XEALSDX0                               04
     C                   END
     C                   CLOSE     YEALSDY0
      *
     C                   ENDSR                                                  **SRDELD ENDSR**
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SR/SRTERM Program termination                                *
      *                                                               *
      *  Called by: S T A R T                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRTERM        BEGSR
      *
     C     *IN80         IFEQ      *ON                                          Database error
      *
      ** Print audit report & stop run
      *
     C                   WRITE     HEADAU                                       Report header
      *
     C                   WRITE     DBERROR                                      Report error
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR                          Last record
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *  Calls    : SRTERM                                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  **PSSR BEGSR**
      *
      ** Prevent recursive call
      *
     C     @@PSSR        IFEQ      'N'                                          Recursive call
      *
     C                   MOVE      'Y'           @@PSSR                         *PSSR Executed
      *
      ** Update local data area
      *
     C     *LOCK         IN        LDA
     C     DBPGM         IFEQ      *BLANKS
     C**********         MOVEL     'GLM056A'     DBPGM                          Set program idLUC109
     C                   MOVEL     'XX00056A'    DBPGM                          Set program idLUC109
     C                   ENDIF
     C                   OUT       LDA
      *
     C                   MOVE      *ON           *IN80                          Database error
     C                   MOVE      *ON           *INU7                                         15996
     C                   MOVE      *ON           *INU8                                         15996
     C                   DUMP                                                   Dump system var
      *
     C                   EXSR      SRTERM                                       Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR                                                  **PSSR ENDSR**
      *****************************************************************
      /EJECT
      *****************************************************************
      ***/C*PY*ZSRSRC,ZCBDYSZ1                                                                LUC109
      /COPY ZSRSRC,XCBDYSZ1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDATE2Z2                                                                LUC109
      /COPY ZSRSRC,ZDATE2Z2LE                                                                 LUC109
     C***/C*PY*ZSRSRC,ZDATE9Z3                                                         MUI009 LUC109
     C***/C*PY*ZSRSRC,ZDAT10Z2                                                         MUI009 LUC109
     C/COPY ZSRSRC,ZDAT10Z2LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDLINTZ1                                                                LUC109
      /COPY ZSRSRC,ZDLINTZ1LE                                                                 LUC109
**  CPY@ OBJECT COPYRIGHT **
(c) Misys International Banking Systems Ltd. 2016
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   @YD  - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
00366007310109601461
**   @MD  - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
