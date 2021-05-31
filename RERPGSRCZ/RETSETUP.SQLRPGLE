     H
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas RE Setup ICD, groups and window records')        *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Retail Module
     F*                                                               *
     F*  RETSETUP - FILES INITIALIZATION                              *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER049             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPK008             Date 17Jun97               *
      *                 078147             Date 01Nov94               *
     F*                 076713             DATE 04OCT94               *
     F*                 070623             DATE 11MAY94               *
     F*                 S01413 *CREATE     DATE 13APR93               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
     F*  CER049 - Stamp Tax (Recompile)                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
     F*  CPK008 - DBA R2 packaging:                                   *
     F*           - Remove the setup of SDFCTLPA and SDMREFPD as      *
     F*             this data is now deliverable data.                *
     F*  078147 - Include set up of TABTREXC from SD9340.             *
     F*                                                               *
     F*  076713 - Initialise retail features to Y and correct set up  *
     F*           of windows records.                                 *
     F*  070623 - Check that a record does not exist on SCSARDPD      *
     F*           for S01413, before adding one.                      *
     F*  S01413 - Retail 3 Incorporation                              *
     F*                                                               *
     F*****************************************************************
     FTABLEV4   UF A E             DISK
     F**
     FTABTBRE   UF A E             DISK
     FTABTREXC  UF A E             DISK                                         078147
     F**
     FTABLETX   UF A E             DISK
     FTABLETXL  IF   E           K DISK
     F                                     RENAME(TABLETXF:TABLETXX)
     F**
     F*SCSARDPD* O  A E             DISK                                                    MD055681
     F**
     F*SDMREFPDO**E***                 DISK                      A        CPK008
     F**********                                                          CPK008
     F*SDFCTLPAO**E***                 DISK                      A        CPK008
     F*********************************************************************
     D*
     D** Copyright Array
     D*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              COPYRIGHT
     D*
     D** Description array
     D*
     D NAR             S             50    DIM(1) CTDATA PERRCD(1)              DESCRIPTION
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D*
     D** Bank Details
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     I*
     ITABLETXF
     I              RECI                        HRECI
     I              RECT                        HRECT
     I              ZZ010                       HZZ010
     I              LCD                         HLCD
     I              CHTP                        HCHTP
     I              TNLU                        HTNLU
     ITABTBREF
     I              RECI                        TRECI
     I*
     I** First DS for access programs, short data structure
     I*
      *********************************************************************
      **
     C*
     C** Copyright Statement
     C*
     C                   MOVEA     CPY@          BIS@             80
      **
     C                   EXSR      FIRST
      **
      **        MAIN PROCESSING
      **        ---------------
      **
      ** SETUP OF TABLEV4
      **
     C     1             SETLL     TABLEV4
     C                   READ      TABLEV4                                80
     C     *IN80         IFEQ      '1'
     C                   MOVE      'P'           WWPROC
     C                   EXSR      #TBV4
     C                   ELSE
     C                   UPDATE    TABLEV4F
     C                   END
      **
      ** SETUP OF TABTBRE
      **
     C     1             SETLL     TABTBRE
     C                   READ      TABTBRE                                81
     C     *IN81         IFEQ      '1'
     C                   EXSR      #TBRE
     C                   ELSE
     C                   UPDATE    TABTBREF
     C                   END
      **                                                                  078147
      ** SETUP OF TABTREXC                                                078147
      **                                                                  078147
     C     1             CHAIN     TABTREXC                           99                       07814
     C     *IN99         IFEQ      '1'                                                         07814
     C                   MOVE      'D'           RERECI                                        07814
     C                   WRITE     TABTREF0                                                    07814
     C                   END                                                                   07814
      **
      ** SETUP OF SCSARDPD
      **
     C                   EXSR      #SARD
      **
      ***SETUP*OF*SDMREFPD*******************************************     CPK008
      **********                                                          CPK008
     C**********           EXSR #MREF                                     CPK008
      **********                                                          CPK008
      ***SETUP*OF*SDFCTLPA******************************************      CPK008
      **********                                                          CPK008
     C**********           EXSR #FCTL                                     CPK008
      **
     C                   MOVE      '1'           *INLR
     C                   RETURN
      **************************************************************************
     C     #TBV4         BEGSR
      **
     C                   Z-ADD     0             WWCONT            2 0
     C     WWCONT        DOUEQ     8
     C                   ADD       1             WWCONT
     C                   MOVE      WWCONT        WWGROP            1
     C                   MOVE      'D'           RECI
     C                   Z-ADD     81            RECT
     C                   MOVE      WWGROP        ZZ010
     C                   MOVE      *BLANKS       GRPN
     C                   MOVE      'N'           MDBI
     C                   MOVE      'N'           ACMI
     C                   MOVE      'N'           DINI
     C                   MOVE      'N'           INAI
     C                   MOVE      'N'           MINI
     C                   MOVE      'N'           DYSI
     C                   MOVE      'N'           FIXI
     C                   Z-ADD     0             MDBA
     C                   Z-ADD     0             ACMA
     C                   Z-ADD     0             DINA
     C                   Z-ADD     0             INAA
     C                   Z-ADD     0             MINA
     C                   Z-ADD     0             DYSA
     C                   Z-ADD     0             FIXA
     C                   Z-ADD     0             TIMV
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   Z-ADD     0             TNLU
     C                   WRITE     TABLEV4F
     C                   END
      **
      ** INITIALIZE TRAILER
      **
     C                   MOVE      '81'          WWKEY             2
     C     WWKEY         CHAIN     TABLETXL                           82
     C     *IN82         IFEQ      '1'
     C                   MOVE      'H'           HRECI
     C                   MOVE      '81'          HRECT
     C                   MOVE      *BLANKS       HZZ010
     C                   Z-ADD     8             NREC
     C                   Z-ADD     0             NINS
     C                   Z-ADD     0             NDEL
     C                   Z-ADD     0             NAMD
     C                   Z-ADD     0             LRNO
     C                   MOVE      *BLANKS       ZZ058
     C                   MOVE      'I'           HCHTP
     C                   Z-ADD     BJRDNB        HLCD
     C                   Z-ADD     0             HTNLU
     C                   WRITE     TABLETXF
     C                   ELSE
     C                   READ      TABLETXF                               84
     C     *IN84         IFEQ      '0'
     C                   UPDATE    TABLETXF
     C                   END
     C                   END
      **
     C                   ENDSR
      **************************************************************************
     C     #TBRE         BEGSR
      **
     C                   MOVE      'D'           TRECI
     C                   MOVE      *BLANK        LNKA
     C                   MOVE      *BLANK        TCAL
     C                   MOVE      *BLANK        CMTR
     C                   MOVE      *BLANK        CDFC
     C                   MOVE      *BLANK        CDTO
     C                   MOVE      *BLANK        CMDR
     C                   MOVE      *BLANK        MDPF
     C                   MOVE      *BLANK        FXAC
     C                   MOVE      *BLANK        CNDS
     C                   MOVE      *BLANK        CDRI
     C                   MOVE      *BLANK        CMBL
     C                   MOVE      *BLANK        CINA
     C                   MOVE      *BLANK        VATP
     C                   MOVE      *BLANK        TEGP
     C                   MOVE      *BLANK        TAIA
     C                   MOVE      *BLANK        ISTS
     C                   MOVE      *BLANK        MAGI
     C                   Z-ADD     1             ICGP
     C                   MOVEL     *BLANKS       HOCO
     C                   MOVE      *BLANK        CHOV
     C                   MOVE      *BLANK        TCDTO
     C                   MOVE      *BLANK        TCHOV
     C                   MOVE      *BLANK        TFXAC
     C                   MOVE      *BLANK        TCNDS
     C                   MOVE      *BLANK        TCMBL
     C                   MOVE      *BLANK        TCDRI
     C                   MOVE      *BLANK        TCINA
     C*********************MOVE *BLANK    TURN                            076713
     C*********************MOVE *BLANK    STMC                            076713
     C                   MOVE      'Y'           TURN                                          07671
     C                   MOVE      'Y'           STMC                                          07671
     C                   MOVE      *BLANK        TTURN
     C                   MOVE      *BLANK        TSTMC
     C                   MOVE      *BLANK        FACH
     C*********************MOVE *BLANK    IFACH                           076713
     C*********************MOVE *BLANK    ILNKA                           076713
     C*********************MOVE *BLANK    ITCAL                           076713
     C*********************MOVE *BLANK    ICMTR                           076713
     C*********************MOVE *BLANK    ICDFC                           076713
     C*********************MOVE *BLANK    ICDTO                           076713
     C*********************MOVE *BLANK    IFXAC                           076713
     C*********************MOVE *BLANK    ICNDS                           076713
     C*********************MOVE *BLANK    ICDRI                           076713
     C*********************MOVE *BLANK    ICMBL                           076713
     C*********************MOVE *BLANK    ICINA                           076713
     C*********************MOVE *BLANK    IVATP                           076713
     C                   MOVE      *BLANK        ITEGP
     C*********************MOVE *BLANK    ITAIA                           076713
     C*********************MOVE *BLANK    ICHOV                           076713
     C                   MOVE      'Y'           IFACH                                         07671
     C                   MOVE      'Y'           ILNKA                                         07671
     C                   MOVE      'Y'           ITCAL                                         07671
     C                   MOVE      'Y'           ICMTR                                         07671
     C                   MOVE      'Y'           ICDFC                                         07671
     C                   MOVE      'Y'           ICDTO                                         07671
     C                   MOVE      'Y'           IFXAC                                         07671
     C                   MOVE      'Y'           ICNDS                                         07671
     C                   MOVE      'Y'           ICDRI                                         07671
     C                   MOVE      'Y'           ICMBL                                         07671
     C                   MOVE      'Y'           ICINA                                         07671
     C                   MOVE      'Y'           IVATP                                         07671
     C                   MOVE      'Y'           ITAIA                                         07671
     C                   MOVE      'Y'           ICHOV                                         07671
     C                   MOVEL     *BLANK        IACSM
     C                   MOVEL     *BLANK        ACSM
     C                   WRITE     TABTBREF
      **
     C                   ENDSR
      **************************************************************************
     C     #SARD         BEGSR
      **
     C                   CALL      'AOSARDR0'                                                  07062
     C                   PARM      '       '     @RTCD                                         07062
     C                   PARM      '*VERIFY'     @OPTN                                         07062
     C                   PARM      'S01413'      @SARD             6                           07062
      *                                                                   070623
     C     @RTCD         IFEQ      '*NRF   '                                                   07062
      *                                                                   070623
     C                   MOVEL     'S01413'      SARN
     C                   MOVEA     NAR           SARD
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'I'           TYLC
     C**********         WRITE     SCSARDD0                                                 MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDBTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , SARD                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :SARN                                                                             MD055681
     C+ , :SARD                                                                             MD055681
     C+ , :LCD                                                                              MD055681
     C+ , 'I'                                                                               MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDXTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :SARN                                                                             MD055681
     C+ , :LCD                                                                              MD055681
     C+ , 'I'                                                                               MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
      *                                                                   070623
     C                   END                                                                   07062
      **
     C                   ENDSR
      **************************************************************************
     C********** #MREF     BEGSR                                          CPK008
      **********                                                          CPK008
     C**********           MOVEL'01'      DLSQNB                          CPK008
     C**********           Z-ADDBJRDNB    DLLCD                           CPK008
     C**********           MOVEL'I'       DLTYLC                          CPK008
     C**********           Z-ADD5         DLLGWD                          CPK008
     C**********           Z-ADD35        DLWDWD                          CPK008
     C***********          Z-ADD1         DLSRWD                          076713
     C***********          Z-ADD1         DLSCWD                          076713
     C**********           Z-ADD12        DLSRWD                          076713
     C**********           Z-ADD15        DLSCWD                          076713
      **********                                                          CPK008
     C***********          MOVEL'SD9205R 'DLNMCP                          076713
     C***********          MOVEL'SD9341R 'DLWNCN                          076713
     C***********          MOVEL'RETICD ' DLTTWD                          076713
     C***********          WRITESDMREFD0                                  076713
      **********                                                          CPK008
     C**********           MOVEL'SD9341E 'DLNMCP                          CPK008
     C**********           MOVEL'SD9341WC'DLWNCN                          CPK008
     C**********           MOVEL'RETICD ' DLTTWD                          CPK008
     C***********          Z-ADD25        DLLGWD                          076713
     C***********          Z-ADD80        DLWDWD                          076713
     C**********           WRITESDMREFD0                                  CPK008
      **********                                                          CPK008
     C**********           MOVEL'SD9341R 'DLNMCP                          CPK008
     C**********           MOVEL'SD9341WC'DLWNCN                          CPK008
     C**********           MOVEL'RETICD ' DLTTWD                          CPK008
     C**********           WRITESDMREFD0                                  CPK008
      **********                                                          CPK008
     C**********           MOVEL'RE0241 ' DLNMCP                          CPK008
     C**********           MOVEL'RE0240WC'DLWNCN                          CPK008
     C**********           MOVEL'RETCCY ' DLTTWD                          CPK008
     C***********          Z-ADD5         DLLGWD                          076713
     C***********          Z-ADD35        DLWDWD                          076713
     C**********           WRITESDMREFD0                                  CPK008
      **********                                                          CPK008
     C**********           MOVEL'RE0242 ' DLNMCP                          CPK008
     C**********           MOVEL'RE0240WC'DLWNCN                          CPK008
     C**********           MOVEL'RETCCY ' DLTTWD                          CPK008
     C**********           WRITESDMREFD0                                  CPK008
      **********                                                          CPK008
     C**********           MOVEL'RE0243 ' DLNMCP                          CPK008
     C**********           MOVEL'RE0240WC'DLWNCN                          CPK008
     C**********           MOVEL'RETCCY ' DLTTWD                          CPK008
     C**********           WRITESDMREFD0                                  CPK008
      **********                                                          CPK008
     C**********           MOVEL'RE0244 ' DLNMCP                          CPK008
     C**********           MOVEL'RE0240WC'DLWNCN                          CPK008
     C**********           MOVEL'RETCCY ' DLTTWD                          CPK008
     C**********           WRITESDMREFD0                                  CPK008
      **********                                                          CPK008
     C***********          MOVEL'GL3271#C'DLNMCP                          076713
     C***********          MOVEL'GL3271WC'DLWNCN                          076713
     C***********          MOVEL'ACMAINT' DLTTWD                          076713
     C***********          WRITESDMREFD0                                  076713
      **********                                                          CPK008
     C**********           MOVEL'GL327A  'DLNMCP                          CPK008
     C**********           MOVEL'GL3271WC'DLWNCN                          CPK008
     C**********           MOVEL'ACMAINT' DLTTWD                          CPK008
     C**********           WRITESDMREFD0                                  CPK008
      **********                                                          CPK008
     C**********           MOVEL'GL327B  'DLNMCP                          CPK008
     C**********           MOVEL'GL3271WC'DLWNCN                          CPK008
     C**********           MOVEL'ACMAINT' DLTTWD                          CPK008
     C**********           WRITESDMREFD0                                  CPK008
      **********                                                          CPK008
     C**********           ENDSR                                          CPK008
      **************************************************************************
     C**********                                                          CPK008
     C********** #FCTL     BEGSR                                          CPK008
     C**********                                                          CPK008
     C*****Initialise fields for SDSAFEPD.                                CPK008
     C**********                                                          CPK008
     C**********           MOVEL'SDSAFEPD'AHFLNM                          CPK008
     C**********           Z-ADD1         AHNORC                          CPK008
     C**********           Z-ADD*ZERO     AHNOIN                          CPK008
     C**********           Z-ADD*ZERO     AHNOAM                          CPK008
     C**********           Z-ADD*ZERO     AHNODL                          CPK008
     C**********           WRITESDFCTLA0                                  CPK008
     C**********                                                          CPK008
     C*****Initialise fields for SDCHEQPD.                                CPK008
     C**********                                                          CPK008
     C**********           MOVEL'SDCHEQPD'AHFLNM                          CPK008
     C**********           Z-ADD1         AHNORC                          CPK008
     C**********           Z-ADD*ZERO     AHNOIN                          CPK008
     C**********           Z-ADD*ZERO     AHNOAM                          CPK008
     C**********           Z-ADD*ZERO     AHNODL                          CPK008
     C**********           WRITESDFCTLA0                                  CPK008
      **********                                                          CPK008
     C**********           ENDSR                                          CPK008
      **************************************************************************
     C     FIRST         BEGSR
      **
     C     *ENTRY        PLIST
     C                   PARM                    WWERR             1
      **
     C                   MOVE      *BLANK        WWERR
     C                   MOVE      *BLANK        WWPROC            1
      **
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'E'           WWERR
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   END
      **
     C                   ENDSR
** CPY@ OBJECT COPYRIGHT
(c) Finastra International Limited 2001
** NAR  SWITCHABLE FEATURES DESCRIPTION
Retail 3
