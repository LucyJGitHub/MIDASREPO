     H DEBUG
      *****************************************************************
/*S*D ***RPGBASE                                                      *                     MD059895
/*STD *  RPGSQLBND                                                    *                     MD059895
/*EXI *  TEXT('Midas MC Install deliverable data for FMD003')         *
      *****************************************************************
      *                                                               *
      *  Midas - Management Accounting Module                         *
      *                                                               *
      *  UTUMD001B - FMD003 Data files setup                          *
      *                                                               *
      *  Called by: UTCLUMD001                                        *
      *                                                               *
      *  (c)  Finastra International Limited 2009                     *
      *                                                               *
      *  Last Amend No. MD059895           Date 02May22               *
      *  Prev Amend No. EML108A            Date 31Aug20               *
      *                 EML108             Date 12Jan09               *
      *                 UMD001             Date 12Jan09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059895 - Converted to SQLRPGLE to address Deliverable      *
      *             Data Split for COB and SAR files                  *
      *  EML108A - Upgrade from FM2.1 SP21 to SP23                    *
      *            (Deliverable data split for RCF - changes reqd)    *
      *  EML108 - Upgrade FMD003 to FBM2.1SP21 (Recompile ONLY NOT    *
      *           FOR USE)                                            *
      *  UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19             *
      *                                                               *
      *****************************************************************
      *
      ** Midas SC Local files to journal (all rec)
     F**FCREPTL0UF  E           K        DISK                      A                      EML108A
     FFCREPJI0  UF A E           K DISK                                                         EML1
      *
      ** Midas FC Report Suffix Update index
     F**FCRSFXL0UF  E           K        DISK                      A                      EML108A
     FFCRSFJI0  UF A E           K DISK                                                         EML1
      *
      ** Midas FC Report Components Update index                                          EML108A
     F**FCRCOML0UF  E           K        DISK                      A                      EML108A
     FFCRCOJI0  UF A E           K DISK
     F*SCSARCL0*  UF A E           K DISK                                                   MD059895
     F*SCSARZL1UF  E           K        DISK                      A
     F*SCSARDL0UF  E           K        DISK                      A
     F*SCSAROL0*  UF A E           K DISK                                                   MD059895
     F*CBCMPNL0*  UF A E           K DISK                                                   MD059895
     F*CBDPRLL5*  UF A E           K DISK                                                   MD059895
     F*CBMEXCL3*  UF A E           K DISK                                                   MD059895
      *
      /EJECT
      *
      ** Field - Description
     D TXT             S             50    DIM(12) CTDATA PERRCD(1)
      *
      ** Copyright statement
      /EJECT
      *  Local data area
     D LDA            UDS           256
     D  DBLOT                134    183
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D SCSARC        E DS                  EXTNAME(SCSRCJW0)                                MD059895
     D SCSARO        E DS                  EXTNAME(SCSROJW0)                                MD059895
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD059895
     D CBDPRL        E DS                  EXTNAME(CBDPRJW0)                                MD059895
     D CBMEXC        E DS                  EXTNAME(CBMEXJW0)                                MD059895

      *  Data Structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      *  Data Structure for Bank Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      *  Data structure for compilation
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      /EJECT
      *  Define the local data area
     C     *DTAARA       DEFINE                  LDA
     C                   MOVEL     'UTUMD001'    DBPGM
      *
      ** Define Key values
     C     *LIKE         DEFINE    AFSARN        #SARN
     C     *LIKE         DEFINE    AFOBNM        #OBNM
     C     *LIKE         DEFINE    AFOBTP        #OBTP
     C     *LIKE         DEFINE    DXRNAM        #RNAM
     C     *LIKE         DEFINE    DYRSFX        #RSFX
     C     *LIKE         DEFINE    D3COTT        #COTT
     C     *LIKE         DEFINE    D3COTT        #COTT1
     C     *LIKE         DEFINE    D3CSEQ        #CSEQ
     C     *LIKE         DEFINE    DHCSEQ        #DSEQ
     C     *LIKE         DEFINE    DHCSEQ        #CSEQ1
     C     *LIKE         DEFINE    DHCSEQ        #DSEQ1
      *
      ** Define Key list for SC Switchable feature objects
     C     KSARO         KLIST
     C                   KFLD                    #SARN
     C                   KFLD                    #OBNM
     C                   KFLD                    #OBTP
      *
      ** Define Key list for FC Report Descriptions
     C     KREPT         KLIST
     C                   KFLD                    #RNAM
      *
      ** Define Key list for FC Report Suffix
     C     KRSFX         KLIST
     C                   KFLD                    #RNAM
     C                   KFLD                    #RSFX
      *
      ** Define Key list for SC Switchable feature report name
     C     KSARR         KLIST
     C                   KFLD                    #SARN
     C                   KFLD                    #RNAM
      *
      ** Define Key list for FC Report Components
     C     KRCOM         KLIST
     C                   KFLD                    #RNAM
     C                   KFLD                    #COTT
     C                   KFLD                    #CSEQ
      *
     C     KSARC         KLIST
     C                   KFLD                    #SARN
     C                   KFLD                    #COTT1
     C                   KFLD                    #CSEQ1
      *
     C     KCBCM         KLIST
     C                   KFLD                    #COTT1
     C                   KFLD                    #DSEQ1
      *
     C     KCBPR         KLIST
     C                   KFLD                    #COTT
     C                   KFLD                    #DSEQ
     C                   KFLD                    #COTT1
     C                   KFLD                    #DSEQ1
      *
     C     KMEXC         KLIST
     C                   KFLD                    #COTT
     C                   KFLD                    #DSEQ
     C                   KFLD                    #COTT1
     C                   KFLD                    #DSEQ1
      *
      *   Call access programm for Bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST'      ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   MOVE      '*CALL   '    DBKEY
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ********************************************************************
      *
      *      MAIN   -   Main part of the processing
      *
      ********************************************************************
      *
     C**********           MOVEL'FMD003'  #SARN     P                              EML108A
     C                   MOVEL(P)  'EML108'      #SARN
      *
      ** Activation of feature FMD003 should be done manually using UTMENU |||
     C*****      #SARN     CHAIN@SARDL0              10
     C*****      *IN10     IFEQ '1'
     C*****                MOVEL#SARN     ABSARN
     C*****                MOVELTXT,1     ABSARD
     C*****                Z-ADDBJRDNB    ABLCD
     C*****                MOVEL'I'       ABTYLC
     C*****                WRITE@SARDL0
     C*****                ENDIF
      *****
      ***Midas SC All non-core SARs keyed on SAR ID
     C*****      #SARN     CHAINSCSARSD0             10
     C*****      *IN10     IFEQ '1'
     C*****                MOVEL#SARN     AXSARN
     C*****                MOVELTXT,1     AXSARD
     C*****                WRITESCSARSD0
     C*****                ENDIF
      *
      ** Midas FC Report Descriptions Setup
     C                   MOVEL(P)  'MC0750'      #RNAM
      *
     C********** KREPT     CHAIN@DXREIJ              90                               EML108A
     C     KREPT         CHAIN     FCREPCT0                           90
      *
      ** Non key fields Setup
     C     *IN90         IFEQ      '1'
     C                   MOVEL     #RNAM         DXRNAM
     C                   Z-ADD     BJRDNB        DXLCD
     C                   MOVE      'I'           DXCHTP
     C                   MOVE      'MC'          DXCMOD
     C                   MOVEL     TXT(2)        DXRDSC
     C                   MOVE      'Y'           DXGLVL
     C                   MOVE      'Y'           DXCLVL
     C                   MOVE      'Y'           DXBLVL
     C                   MOVE      'Y'           DXALVL
     C                   MOVE      'Y'           DXDLVL
     C                   MOVE      'Y'           DXIPCY
     C                   MOVE      'Y'           DXCLBP
     C                   MOVE      'Y'           DXPDFL
     C                   MOVE      *BLANKS       DXDFTO
     C                   MOVE      'N'           DXMIDQ
     C**********           WRITE@DXREIJ                                                  EML108A
     C                   WRITE     FCREPCT0
     C                   ENDIF
      *
      ** Midas FC Report Suffix Setup
     C                   MOVEL(P)  'MC0750'      #RNAM
     C                   MOVEL(P)  'MCF750P1'    #RSFX
      *
     C********** KRSFX     CHAIN@DYREIN              90                                  EML108A
     C     KRSFX         CHAIN     FCRSFCT0                           90
      *
      ** Non key fields Setup
     C     *IN90         IFEQ      '1'
     C                   MOVEL     #RNAM         DYRNAM
     C                   MOVEL     #RSFX         DYRSFX
     C                   MOVE      'N'           DYAURP
     C                   MOVEL     TXT(3)        DYPFTX
     C                   MOVE      'N'           DYCOLT
     C**********           WRITE@DYREIN                                                  EML108A
     C                   WRITE     FCRSFCT0
     C                   ENDIF
      *
      ** Midas FC Switchable feature report name Setup
      *
      ** Midas FC Switchable feature report objects Setup
     C                   MOVEL(P)  'MCF750P1'    #OBNM
     C                   MOVEL(P)  '*FILE'       #OBTP
      *
     C*****KSARO         CHAIN     @SAROL0                            90                    MD059895
      *
      ** Non key fields Setup
     C******IN90         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #SARN         AFSARN                                     MD059895
     C**********         MOVEL     #OBNM         AFOBNM                                     MD059895
     C**********         MOVEL     #OBTP         AFOBTP                                     MD059895
     C**********         MOVEL(P)  'PRTF'        AFOBAT                                     MD059895
     C**********         MOVE      'Y'           AFAVAL                                     MD059895
     C**********         MOVEL     TXT(3)        AFOBTX                                     MD059895
     C**********         Z-ADD     BJRDNB        AFLCD                                      MD059895
     C**********         MOVE      'I'           AFTYLC                                     MD059895
     C**********         WRITE     @SAROL0                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :SCSARO                                                                        MD059895
     C+ from SCSROJW0                                                                       MD059895
     C+ where AFSARN = :#SARN and AFOBNM = :#OBNM and AFOBTP = :#OBTP                       MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     TXT(3)        #OBTX            50                        MD059895
     C                   EXSR      INSSARO                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
      ** Midas FC Report Components Setup
     C                   MOVEL(P)  'MC0750'      #RNAM
     C                   MOVEL(P)  'MCC84'       #COTT
     C                   MOVEL(P)  '10001'       #CSEQ
      *
     C********** KRCOM     CHAIN@D3REI4              90                                  EML108A
     C     KRCOM         CHAIN     FCRCOCT0                           90
      *
      ** Non key fields Setup
     C     *IN90         IFEQ      '1'
     C                   MOVEL     #RNAM         D3RNAM
     C                   MOVEL     #COTT         D3COTT
     C                   MOVEL     #CSEQ         D3CSEQ
     C                   MOVE      'R'           D3MORQ
     C                   MOVE      *BLANKS       D3CLPM
     C                   MOVE      'MCC84'       D3PRPG
     C                   MOVE      *BLANKS       D3ADTX
     C                   MOVE      'B'           D3BRTP
     C**********           WRITE@D3REI4                                                   EML108A
     C                   WRITE     FCRCOCT0
     C                   ENDIF
      *
     C                   MOVEL(P)  'MCCF690'     #COTT1
     C                   MOVEL(P)  '00001'       #CSEQ1
      *
     C*****KSARC         CHAIN     @SARCL0                            90                    MD059895
     C******IN90         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #SARN         ACSARN                                     MD059895
     C**********         MOVEL     #COTT1        ACCOTT                                     MD059895
     C**********         MOVEL     #CSEQ1        ACCSEQ                                     MD059895
     C**********         MOVEL     'Y'           ACAVAL                                     MD059895
     C**********         MOVEL     'I'           ACTYLC                                     MD059895
     C**********         Z-ADD     BJRDNB        ACLCD                                      MD059895
     C**********         WRITE     @SARCL0                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :SCSARC                                                                        MD059895
     C+ from SCSRCJW0                                                                       MD059895
     C+ where ACSARN = :#SARN and ACCOTT = :#COTT1 and ACCSEQ = :#CSEQ1                     MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   EXSR      INSSARC                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL(P)  'MCCF790'     #COTT1
     C                   MOVEL(P)  '00001'       #CSEQ1
      *
     C*****KSARC         CHAIN     @SARCL0                            90                    MD059895
     C******IN90         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #SARN         ACSARN                                     MD059895
     C**********         MOVEL     #COTT1        ACCOTT                                     MD059895
     C**********         MOVEL     #CSEQ1        ACCSEQ                                     MD059895
     C**********         MOVEL     'Y'           ACAVAL                                     MD059895
     C**********         MOVEL     'I'           ACTYLC                                     MD059895
     C**********         Z-ADD     BJRDNB        ACLCD                                      MD059895
     C**********         WRITE     @SARCL0                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :SCSARC                                                                        MD059895
     C+ from SCSRCJW0                                                                       MD059895
     C+ where ACSARN = :#SARN and ACCOTT = :#COTT1 and ACCSEQ = :#CSEQ1                     MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   EXSR      INSSARC                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL(P)  'MCCF890'     #COTT1
     C                   MOVEL(P)  '00001'       #CSEQ1
      *
     C*****KSARC         CHAIN     @SARCL0                            90                    MD059895
     C******IN90         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #SARN         ACSARN                                     MD059895
     C**********         MOVEL     #COTT1        ACCOTT                                     MD059895
     C**********         MOVEL     #CSEQ1        ACCSEQ                                     MD059895
     C**********         MOVEL     'Y'           ACAVAL                                     MD059895
     C**********         MOVEL     'I'           ACTYLC                                     MD059895
     C**********         Z-ADD     BJRDNB        ACLCD                                      MD059895
     C**********         WRITE     @SARCL0                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :SCSARC                                                                        MD059895
     C+ from SCSRCJW0                                                                       MD059895
     C+ where ACSARN = :#SARN and ACCOTT = :#COTT1 and ACCSEQ = :#CSEQ1                     MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   EXSR      INSSARC                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL(P)  'MCCF990'     #COTT1
     C                   MOVEL(P)  '00001'       #CSEQ1
      *
     C*****KSARC         CHAIN     @SARCL0                            90                    MD059895
     C******IN90         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #SARN         ACSARN                                     MD059895
     C**********         MOVEL     #COTT1        ACCOTT                                     MD059895
     C**********         MOVEL     #CSEQ1        ACCSEQ                                     MD059895
     C**********         MOVEL     'Y'           ACAVAL                                     MD059895
     C**********         MOVEL     'I'           ACTYLC                                     MD059895
     C**********         Z-ADD     BJRDNB        ACLCD                                      MD059895
     C**********         WRITE     @SARCL0                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :SCSARC                                                                        MD059895
     C+ from SCSRCJW0                                                                       MD059895
     C+ where ACSARN = :#SARN and ACCOTT = :#COTT1 and ACCSEQ = :#CSEQ1                     MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   EXSR      INSSARC                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL(P)  'MCCF690'     #COTT1
     C                   MOVEL(P)  '00001'       #DSEQ1
     C*****KCBCM         CHAIN     @DHREGG                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT1        DHCOTT                                     MD059895
     C**********         MOVEL     #DSEQ1        DHCSEQ                                     MD059895
     C**********         MOVEL     ' '           DHCSTS                                     MD059895
     C**********         Z-ADD     5             DHCSHP                                     MD059895
     C**********         Z-ADD     20            DHCEPY                                     MD059895
     C**********         Z-ADD     1000          DHCTSL                                     MD059895
     C**********         MOVEL     'N'           DHCFOB                                     MD059895
     C**********         MOVEL     TXT(10)       DHCTXT                                     MD059895
     C**********         MOVEL     *BLANKS       DHCPRM                                     MD059895
     C**********         MOVEL     'N'           DHCRQD                                     MD059895
     C**********         MOVEL     'MC'          DHCMOD                                     MD059895
     C**********         MOVEL     'N'           DHCEMI                                     MD059895
     C**********         MOVEL     'N'           DHCRES                                     MD059895
     C**********         Z-ADD     1             DHCODP                                     MD059895
     C**********         MOVEL     'Y'           DHCMEF                                     MD059895
     C**********         MOVEL     '01'          DHCFRQ                                     MD059895
     C**********         Z-ADD     0             DHCSDE                                     MD059895
     C**********         Z-ADD     0             DHCSTI                                     MD059895
     C**********         Z-ADD     0             DHCEDE                                     MD059895
     C**********         Z-ADD     0             DHCETI                                     MD059895
     C**********         MOVEL     'N'           DHCHTB                                     MD059895
     C**********         MOVEL     'N'           DHCHTA                                     MD059895
     C**********         MOVEL     'N'           DHCFAL                                     MD059895
     C**********         Z-ADD     0             DHEODT                                     MD059895
     C**********         Z-ADD     0             DHEOMT                                     MD059895
     C**********         Z-ADD     0             DHBOMT                                     MD059895
     C**********         Z-ADD     0             DHEOYT                                     MD059895
     C**********         Z-ADD     0             DHEODC                                     MD059895
     C**********         Z-ADD     0             DHEOMC                                     MD059895
     C**********         Z-ADD     0             DHBOMC                                     MD059895
     C**********         Z-ADD     0             DHEOYC                                     MD059895
     C**********         MOVEL     'N'           DHABIC                                     MD059895
     C**********         MOVEL     *BLANKS       DHCBSN                                     MD059895
     C**********         MOVEL     *BLANKS       DHTASK                                     MD059895
     C**********         Z-ADD     0             DHTSNO                                     MD059895
     C**********         WRITE     @DHREGG                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBCMPN                                                                        MD059895
     C+ from CBCMPJW0                                                                       MD059895
     C+ where DHCOTT = :#COTT1 and DHCSEQ = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CSTS            1                        MD059895
     C                   Z-ADD     5             #1CSHP            1 0                      MD059895
     C                   Z-ADD     20            #1CEPY            2 0                      MD059895
     C                   Z-ADD     1000          #1CTSL           11 0                      MD059895
     C                   MOVEL     'N'           #1CFOB            1                        MD059895
     C                   MOVEL     TXT(10)       #1CTXT           60                        MD059895
     C                   MOVEL     *BLANKS       #1CPRM          100                        MD059895
     C                   MOVEL     'N'           #1CRQD            1                        MD059895
     C                   MOVEL     'MC'          #1CMOD            2                        MD059895
     C                   MOVEL     'N'           #1CEMI            1                        MD059895
     C                   MOVEL     'N'           #1CRES            1                        MD059895
     C                   Z-ADD     1             #1CODP            5 0                      MD059895
     C                   MOVEL     'Y'           #1CMEF            1                        MD059895
     C                   MOVEL     '01'          #1CFRQ            2                        MD059895
     C                   Z-ADD     0             #1CSDE            5 0                      MD059895
     C                   Z-ADD     0             #1CSTI            6 0                      MD059895
     C                   Z-ADD     0             #1CEDE            5 0                      MD059895
     C                   Z-ADD     0             #1CETI            6 0                      MD059895
     C                   MOVEL     'N'           #1CHTB            1                        MD059895
     C                   MOVEL     'N'           #1CHTA            1                        MD059895
     C                   MOVEL     'N'           #1CFAL            1                        MD059895
     C                   Z-ADD     0             #1EODT            6 0                      MD059895
     C                   Z-ADD     0             #1EOMT            6 0                      MD059895
     C                   Z-ADD     0             #1BOMT            6 0                      MD059895
     C                   Z-ADD     0             #1EOYT            6 0                      MD059895
     C                   Z-ADD     0             #1EODC            6 0                      MD059895
     C                   Z-ADD     0             #1EOMC            6 0                      MD059895
     C                   Z-ADD     0             #1BOMC            6 0                      MD059895
     C                   Z-ADD     0             #1EOYC            6 0                      MD059895
     C                   MOVEL     'N'           #1ABIC            1                        MD059895
     C                   MOVEL     *BLANKS       #1CBSN            8                        MD059895
     C                   MOVEL     *BLANKS       #1TASK            1                        MD059895
     C                   Z-ADD     0             #1TSNO            3 0                      MD059895
     C                   EXSR      INSCMPN                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL(P)  'MCCF790'     #COTT1
     C                   MOVEL(P)  '00001'       #DSEQ1
     C*****KCBCM         CHAIN     @DHREGG                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT1        DHCOTT                                     MD059895
     C**********                   MOVEL     #DSEQ1        DHCSEQ                           MD059895
     C**********                   MOVEL     ' '           DHCSTS                           MD059895
     C**********                   Z-ADD     5             DHCSHP                           MD059895
     C**********                   Z-ADD     20            DHCEPY                           MD059895
     C**********                   Z-ADD     1000          DHCTSL                           MD059895
     C**********                   MOVEL     'N'           DHCFOB                           MD059895
     C**********                   MOVEL     TXT(11)       DHCTXT                           MD059895
     C**********                   MOVEL     *BLANKS       DHCPRM                           MD059895
     C**********                   MOVEL     'N'           DHCRQD                           MD059895
     C**********                   MOVEL     'MC'          DHCMOD                           MD059895
     C**********                   MOVEL     'N'           DHCEMI                           MD059895
     C**********                   MOVEL     'N'           DHCRES                           MD059895
     C**********                   Z-ADD     1             DHCODP                           MD059895
     C**********                   MOVEL     'N'           DHCMEF                           MD059895
     C**********                   MOVEL     '22'          DHCFRQ                           MD059895
     C**********                   Z-ADD     0             DHCSDE                           MD059895
     C**********                   Z-ADD     0             DHCSTI                           MD059895
     C**********                   Z-ADD     0             DHCEDE                           MD059895
     C**********                   Z-ADD     0             DHCETI                           MD059895
     C**********                   MOVEL     'N'           DHCHTB                           MD059895
     C**********                   MOVEL     'N'           DHCHTA                           MD059895
     C**********                   MOVEL     'N'           DHCFAL                           MD059895
     C**********                   Z-ADD     0             DHEODT                           MD059895
     C**********                   Z-ADD     0             DHEOMT                           MD059895
     C**********                   Z-ADD     0             DHBOMT                           MD059895
     C**********                   Z-ADD     0             DHEOYT                           MD059895
     C**********                   Z-ADD     0             DHEODC                           MD059895
     C**********                   Z-ADD     0             DHEOMC                           MD059895
     C**********                   Z-ADD     0             DHBOMC                           MD059895
     C**********                   Z-ADD     0             DHEOYC                           MD059895
     C**********                   MOVEL     'N'           DHABIC                           MD059895
     C**********                   MOVEL     *BLANKS       DHCBSN                           MD059895
     C**********                   MOVEL     *BLANKS       DHTASK                           MD059895
     C**********                   Z-ADD     0             DHTSNO                           MD059895
     C**********                   WRITE     @DHREGG                                        MD059895
     C**********                   ENDIF                                                    MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBCMPN                                                                        MD059895
     C+ from CBCMPJW0                                                                       MD059895
     C+ where DHCOTT = :#COTT1 and DHCSEQ = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CSTS                                     MD059895
     C                   Z-ADD     5             #1CSHP                                     MD059895
     C                   Z-ADD     20            #1CEPY                                     MD059895
     C                   Z-ADD     1000          #1CTSL                                     MD059895
     C                   MOVEL     'N'           #1CFOB                                     MD059895
     C                   MOVEL     TXT(11)       #1CTXT                                     MD059895
     C                   MOVEL     *BLANKS       #1CPRM                                     MD059895
     C                   MOVEL     'N'           #1CRQD                                     MD059895
     C                   MOVEL     'MC'          #1CMOD                                     MD059895
     C                   MOVEL     'N'           #1CEMI                                     MD059895
     C                   MOVEL     'N'           #1CRES                                     MD059895
     C                   Z-ADD     1             #1CODP                                     MD059895
     C                   MOVEL     'Y'           #1CMEF                                     MD059895
     C                   MOVEL     '22'          #1CFRQ                                     MD059895
     C                   Z-ADD     0             #1CSDE                                     MD059895
     C                   Z-ADD     0             #1CSTI                                     MD059895
     C                   Z-ADD     0             #1CEDE                                     MD059895
     C                   Z-ADD     0             #1CETI                                     MD059895
     C                   MOVEL     'N'           #1CHTB                                     MD059895
     C                   MOVEL     'N'           #1CHTA                                     MD059895
     C                   MOVEL     'N'           #1CFAL                                     MD059895
     C                   Z-ADD     0             #1EODT                                     MD059895
     C                   Z-ADD     0             #1EOMT                                     MD059895
     C                   Z-ADD     0             #1BOMT                                     MD059895
     C                   Z-ADD     0             #1EOYT                                     MD059895
     C                   Z-ADD     0             #1EODC                                     MD059895
     C                   Z-ADD     0             #1EOMC                                     MD059895
     C                   Z-ADD     0             #1BOMC                                     MD059895
     C                   Z-ADD     0             #1EOYC                                     MD059895
     C                   MOVEL     'N'           #1ABIC                                     MD059895
     C                   MOVEL     *BLANKS       #1CBSN                                     MD059895
     C                   MOVEL     *BLANKS       #1TASK                                     MD059895
     C                   Z-ADD     0             #1TSNO                                     MD059895
     C                   EXSR      INSCMPN                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL(P)  'MCCF890'     #COTT1
     C                   MOVEL(P)  '00001'       #DSEQ1
     C*****KCBCM         CHAIN     @DHREGG                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT1        DHCOTT                                     MD059895
     C**********         MOVEL     #DSEQ1        DHCSEQ                                     MD059895
     C**********         MOVEL     ' '           DHCSTS                                     MD059895
     C**********         Z-ADD     5             DHCSHP                                     MD059895
     C**********         Z-ADD     20            DHCEPY                                     MD059895
     C**********         Z-ADD     1000          DHCTSL                                     MD059895
     C**********         MOVEL     'N'           DHCFOB                                     MD059895
     C**********         MOVEL     TXT(12)       DHCTXT                                     MD059895
     C**********         MOVEL     *BLANKS       DHCPRM                                     MD059895
     C**********         MOVEL     'N'           DHCRQD                                     MD059895
     C**********         MOVEL     'MC'          DHCMOD                                     MD059895
     C**********         MOVEL     'N'           DHCEMI                                     MD059895
     C**********         MOVEL     'N'           DHCRES                                     MD059895
     C**********         Z-ADD     1             DHCODP                                     MD059895
     C**********         MOVEL     'N'           DHCMEF                                     MD059895
     C**********         MOVEL     '01'          DHCFRQ                                     MD059895
     C**********         Z-ADD     0             DHCSDE                                     MD059895
     C**********         Z-ADD     0             DHCSTI                                     MD059895
     C**********         Z-ADD     0             DHCEDE                                     MD059895
     C**********         Z-ADD     0             DHCETI                                     MD059895
     C**********         MOVEL     'N'           DHCHTB                                     MD059895
     C**********         MOVEL     'N'           DHCHTA                                     MD059895
     C**********         MOVEL     'N'           DHCFAL                                     MD059895
     C**********         Z-ADD     0             DHEODT                                     MD059895
     C**********         Z-ADD     0             DHEOMT                                     MD059895
     C**********         Z-ADD     0             DHBOMT                                     MD059895
     C**********         Z-ADD     0             DHEOYT                                     MD059895
     C**********         Z-ADD     0             DHEODC                                     MD059895
     C**********         Z-ADD     0             DHEOMC                                     MD059895
     C**********         Z-ADD     0             DHBOMC                                     MD059895
     C**********         Z-ADD     0             DHEOYC                                     MD059895
     C**********         MOVEL     'N'           DHABIC                                     MD059895
     C**********         MOVEL     *BLANKS       DHCBSN                                     MD059895
     C**********         MOVEL     *BLANKS       DHTASK                                     MD059895
     C**********         Z-ADD     0             DHTSNO                                     MD059895
     C**********         WRITE     @DHREGG                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBCMPN                                                                        MD059895
     C+ from CBCMPJW0                                                                       MD059895
     C+ where DHCOTT = :#COTT1 and DHCSEQ = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CSTS                                     MD059895
     C                   Z-ADD     5             #1CSHP                                     MD059895
     C                   Z-ADD     20            #1CEPY                                     MD059895
     C                   Z-ADD     1000          #1CTSL                                     MD059895
     C                   MOVEL     'N'           #1CFOB                                     MD059895
     C                   MOVEL     TXT(12)       #1CTXT                                     MD059895
     C                   MOVEL     *BLANKS       #1CPRM                                     MD059895
     C                   MOVEL     'N'           #1CRQD                                     MD059895
     C                   MOVEL     'MC'          #1CMOD                                     MD059895
     C                   MOVEL     'N'           #1CEMI                                     MD059895
     C                   MOVEL     'N'           #1CRES                                     MD059895
     C                   Z-ADD     1             #1CODP                                     MD059895
     C                   MOVEL     'Y'           #1CMEF                                     MD059895
     C                   MOVEL     '01'          #1CFRQ                                     MD059895
     C                   Z-ADD     0             #1CSDE                                     MD059895
     C                   Z-ADD     0             #1CSTI                                     MD059895
     C                   Z-ADD     0             #1CEDE                                     MD059895
     C                   Z-ADD     0             #1CETI                                     MD059895
     C                   MOVEL     'N'           #1CHTB                                     MD059895
     C                   MOVEL     'N'           #1CHTA                                     MD059895
     C                   MOVEL     'N'           #1CFAL                                     MD059895
     C                   Z-ADD     0             #1EODT                                     MD059895
     C                   Z-ADD     0             #1EOMT                                     MD059895
     C                   Z-ADD     0             #1BOMT                                     MD059895
     C                   Z-ADD     0             #1EOYT                                     MD059895
     C                   Z-ADD     0             #1EODC                                     MD059895
     C                   Z-ADD     0             #1EOMC                                     MD059895
     C                   Z-ADD     0             #1BOMC                                     MD059895
     C                   Z-ADD     0             #1EOYC                                     MD059895
     C                   MOVEL     'N'           #1ABIC                                     MD059895
     C                   MOVEL     *BLANKS       #1CBSN                                     MD059895
     C                   MOVEL     *BLANKS       #1TASK                                     MD059895
     C                   Z-ADD     0             #1TSNO                                     MD059895
     C                   EXSR      INSCMPN                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL(P)  'MCCF990'     #COTT1
     C                   MOVEL(P)  '00001'       #DSEQ1
     C*****KCBCM         CHAIN     @DHREGG                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT1        DHCOTT                                     MD059895
     C**********         MOVEL     #DSEQ1        DHCSEQ                                     MD059895
     C**********         MOVEL     ' '           DHCSTS                                     MD059895
     C**********         Z-ADD     5             DHCSHP                                     MD059895
     C**********         Z-ADD     20            DHCEPY                                     MD059895
     C**********         Z-ADD     1000          DHCTSL                                     MD059895
     C**********         MOVEL     'N'           DHCFOB                                     MD059895
     C**********         MOVEL     TXT(4)        DHCTXT                                     MD059895
     C**********         MOVEL     *BLANKS       DHCPRM                                     MD059895
     C**********         MOVEL     'N'           DHCRQD                                     MD059895
     C**********         MOVEL     'MC'          DHCMOD                                     MD059895
     C**********         MOVEL     'N'           DHCEMI                                     MD059895
     C**********         MOVEL     'N'           DHCRES                                     MD059895
     C**********         Z-ADD     1             DHCODP                                     MD059895
     C**********         MOVEL     'Y'           DHCMEF                                     MD059895
     C**********         MOVEL     '01'          DHCFRQ                                     MD059895
     C**********         Z-ADD     0             DHCSDE                                     MD059895
     C**********         Z-ADD     0             DHCSTI                                     MD059895
     C**********         Z-ADD     0             DHCEDE                                     MD059895
     C**********         Z-ADD     0             DHCETI                                     MD059895
     C**********         MOVEL     'N'           DHCHTB                                     MD059895
     C**********         MOVEL     'N'           DHCHTA                                     MD059895
     C**********         MOVEL     'N'           DHCFAL                                     MD059895
     C**********         Z-ADD     0             DHEODT                                     MD059895
     C**********         Z-ADD     0             DHEOMT                                     MD059895
     C**********         Z-ADD     0             DHBOMT                                     MD059895
     C**********         Z-ADD     0             DHEOYT                                     MD059895
     C**********         Z-ADD     0             DHEODC                                     MD059895
     C**********         Z-ADD     0             DHEOMC                                     MD059895
     C**********         Z-ADD     0             DHBOMC                                     MD059895
     C**********         Z-ADD     0             DHEOYC                                     MD059895
     C**********         MOVEL     'N'           DHABIC                                     MD059895
     C**********         MOVEL     *BLANKS       DHCBSN                                     MD059895
     C**********         MOVEL     *BLANKS       DHTASK                                     MD059895
     C**********         Z-ADD     0             DHTSNO                                     MD059895
     C**********         WRITE     @DHREGG                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBCMPN                                                                        MD059895
     C+ from CBCMPJW0                                                                       MD059895
     C+ where DHCOTT = :#COTT1 and DHCSEQ = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CSTS                                     MD059895
     C                   Z-ADD     5             #1CSHP                                     MD059895
     C                   Z-ADD     20            #1CEPY                                     MD059895
     C                   Z-ADD     1000          #1CTSL                                     MD059895
     C                   MOVEL     'N'           #1CFOB                                     MD059895
     C                   MOVEL     TXT(4)        #1CTXT                                     MD059895
     C                   MOVEL     *BLANKS       #1CPRM                                     MD059895
     C                   MOVEL     'N'           #1CRQD                                     MD059895
     C                   MOVEL     'MC'          #1CMOD                                     MD059895
     C                   MOVEL     'N'           #1CEMI                                     MD059895
     C                   MOVEL     'N'           #1CRES                                     MD059895
     C                   Z-ADD     1             #1CODP                                     MD059895
     C                   MOVEL     'Y'           #1CMEF                                     MD059895
     C                   MOVEL     '01'          #1CFRQ                                     MD059895
     C                   Z-ADD     0             #1CSDE                                     MD059895
     C                   Z-ADD     0             #1CSTI                                     MD059895
     C                   Z-ADD     0             #1CEDE                                     MD059895
     C                   Z-ADD     0             #1CETI                                     MD059895
     C                   MOVEL     'N'           #1CHTB                                     MD059895
     C                   MOVEL     'N'           #1CHTA                                     MD059895
     C                   MOVEL     'N'           #1CFAL                                     MD059895
     C                   Z-ADD     0             #1EODT                                     MD059895
     C                   Z-ADD     0             #1EOMT                                     MD059895
     C                   Z-ADD     0             #1BOMT                                     MD059895
     C                   Z-ADD     0             #1EOYT                                     MD059895
     C                   Z-ADD     0             #1EODC                                     MD059895
     C                   Z-ADD     0             #1EOMC                                     MD059895
     C                   Z-ADD     0             #1BOMC                                     MD059895
     C                   Z-ADD     0             #1EOYC                                     MD059895
     C                   MOVEL     'N'           #1ABIC                                     MD059895
     C                   MOVEL     *BLANKS       #1CBSN                                     MD059895
     C                   MOVEL     *BLANKS       #1TASK                                     MD059895
     C                   Z-ADD     0             #1TSNO                                     MD059895
     C                   EXSR      INSCMPN                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL(P)  'MCC84'       #COTT1
     C                   MOVEL(P)  '10001'       #DSEQ1
     C*****KCBCM         CHAIN     @DHREGG                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT1        DHCOTT                                     MD059895
     C**********         MOVEL     #DSEQ1        DHCSEQ                                     MD059895
     C**********         Z-ADD     5             DHCSHP                                     MD059895
     C**********         Z-ADD     20            DHCEPY                                     MD059895
     C**********         Z-ADD     1000          DHCTSL                                     MD059895
     C**********         MOVEL     'N'           DHCFOB                                     MD059895
     C**********         MOVEL     TXT(5)        DHCTXT                                     MD059895
     C**********         MOVEL     *BLANKS       DHCPRM                                     MD059895
     C**********         MOVEL     'N'           DHCRQD                                     MD059895
     C**********         MOVEL     'MC'          DHCMOD                                     MD059895
     C**********         MOVEL     'N'           DHCEMI                                     MD059895
     C**********         MOVEL     'N'           DHCRES                                     MD059895
     C**********         Z-ADD     1             DHCODP                                     MD059895
     C**********         MOVEL     'N'           DHCMEF                                     MD059895
     C**********         MOVEL     '00'          DHCFRQ                                     MD059895
     C**********         Z-ADD     0             DHCSDE                                     MD059895
     C**********         Z-ADD     0             DHCSTI                                     MD059895
     C**********         Z-ADD     0             DHCEDE                                     MD059895
     C**********         Z-ADD     0             DHCETI                                     MD059895
     C**********         MOVEL     'N'           DHCHTB                                     MD059895
     C**********         MOVEL     'N'           DHCHTA                                     MD059895
     C**********         MOVEL     'N'           DHCFAL                                     MD059895
     C**********         Z-ADD     0             DHEODT                                     MD059895
     C**********         Z-ADD     0             DHEOMT                                     MD059895
     C**********         Z-ADD     0             DHBOMT                                     MD059895
     C**********         Z-ADD     0             DHEOYT                                     MD059895
     C**********         Z-ADD     0             DHEODC                                     MD059895
     C**********         Z-ADD     0             DHEOMC                                     MD059895
     C**********         Z-ADD     0             DHBOMC                                     MD059895
     C**********         Z-ADD     0             DHEOYC                                     MD059895
     C**********         MOVEL     'N'           DHABIC                                     MD059895
     C**********         MOVEL     *BLANKS       DHCBSN                                     MD059895
     C**********         MOVEL     *BLANKS       DHTASK                                     MD059895
     C**********         Z-ADD     0             DHTSNO                                     MD059895
     C**********         WRITE     @DHREGG                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBCMPN                                                                        MD059895
     C+ from CBCMPJW0                                                                       MD059895
     C+ where DHCOTT = :#COTT1 and DHCSEQ = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CSTS                                     MD059895
     C                   Z-ADD     5             #1CSHP                                     MD059895
     C                   Z-ADD     20            #1CEPY                                     MD059895
     C                   Z-ADD     1000          #1CTSL                                     MD059895
     C                   MOVEL     'N'           #1CFOB                                     MD059895
     C                   MOVEL     TXT(5)        #1CTXT                                     MD059895
     C                   MOVEL     *BLANKS       #1CPRM                                     MD059895
     C                   MOVEL     'N'           #1CRQD                                     MD059895
     C                   MOVEL     'MC'          #1CMOD                                     MD059895
     C                   MOVEL     'N'           #1CEMI                                     MD059895
     C                   MOVEL     'N'           #1CRES                                     MD059895
     C                   Z-ADD     1             #1CODP                                     MD059895
     C                   MOVEL     'Y'           #1CMEF                                     MD059895
     C                   MOVEL     '00'          #1CFRQ                                     MD059895
     C                   Z-ADD     0             #1CSDE                                     MD059895
     C                   Z-ADD     0             #1CSTI                                     MD059895
     C                   Z-ADD     0             #1CEDE                                     MD059895
     C                   Z-ADD     0             #1CETI                                     MD059895
     C                   MOVEL     'N'           #1CHTB                                     MD059895
     C                   MOVEL     'N'           #1CHTA                                     MD059895
     C                   MOVEL     'N'           #1CFAL                                     MD059895
     C                   Z-ADD     0             #1EODT                                     MD059895
     C                   Z-ADD     0             #1EOMT                                     MD059895
     C                   Z-ADD     0             #1BOMT                                     MD059895
     C                   Z-ADD     0             #1EOYT                                     MD059895
     C                   Z-ADD     0             #1EODC                                     MD059895
     C                   Z-ADD     0             #1EOMC                                     MD059895
     C                   Z-ADD     0             #1BOMC                                     MD059895
     C                   Z-ADD     0             #1EOYC                                     MD059895
     C                   MOVEL     'N'           #1ABIC                                     MD059895
     C                   MOVEL     *BLANKS       #1CBSN                                     MD059895
     C                   MOVEL     *BLANKS       #1TASK                                     MD059895
     C                   Z-ADD     0             #1TSNO                                     MD059895
     C                   EXSR      INSCMPN                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'MCCF690'     #COTT
     C                   MOVEL     '00001'       #DSEQ
     C                   MOVEL     'GLC42'       #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @DPRLL5                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DIDSON                                     MD059895
     C**********         MOVEL     #DSEQ         DIDSOS                                     MD059895
     C**********         MOVEL     '001'         DIDRUN                                     MD059895
     C**********         MOVEL     #COTT1        DIDDON                                     MD059895
     C**********         MOVEL     #DSEQ1        DIDDOS                                     MD059895
     C**********         MOVEL     ' '           DICDST                                     MD059895
     C**********         WRITE     @DPRLL5                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBDPRL                                                                        MD059895
     C+ from CBDPRJW0                                                                       MD059895
     C+ where DIDSON = :#COTT and DIDSOS = :#DSEQ  and                                      MD059895
     C+       DIDDON = :#COTT1 and DIDDOS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CDTS            1                        MD059895
     C                   MOVEL     '001'         #1DRUN            3                        MD059895
     C                   EXSR      INSDPRL                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'MCCF990'     #COTT
     C                   MOVEL     '00001'       #DSEQ
     C                   MOVEL     'MCCF690'     #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @DPRLL5                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DIDSON                                     MD059895
     C**********         MOVEL     #DSEQ         DIDSOS                                     MD059895
     C**********         MOVEL     '900'         DIDRUN                                     MD059895
     C**********         MOVEL     #COTT1        DIDDON                                     MD059895
     C**********         MOVEL     #DSEQ1        DIDDOS                                     MD059895
     C**********         MOVEL     ' '           DICDST                                     MD059895
     C**********         WRITE     @DPRLL5                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBDPRL                                                                        MD059895
     C+ from CBDPRJW0                                                                       MD059895
     C+ where DIDSON = :#COTT and DIDSOS = :#DSEQ  and                                      MD059895
     C+       DIDDON = :#COTT1 and DIDDOS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CDTS            1                        MD059895
     C                   MOVEL     '900'         #1DRUN            3                        MD059895
     C                   EXSR      INSDPRL                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'MCCF690'     #COTT
     C                   MOVEL     '00001'       #DSEQ
     C                   MOVEL     'GLC2000'     #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @MEXCL3                            10
     C******IN10         IFEQ      '1'
     C**********         MOVEL     #COTT         DKCOTT
     C**********         MOVEL     #DSEQ         DKCSEQ
     C**********         MOVEL     '98'          DKMEUN
     C**********         MOVEL     #COTT1        DKMECN
     C**********         MOVEL     #DSEQ1        DKMECS
     C**********         WRITE     @MEXCL3
     C**********         ENDIF
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBMEXC                                                                        MD059895
     C+ from CBMEXJW0                                                                       MD059895
     C+ where DKCOTT = :#COTT and DKCSEQ = :#DSEQ  and                                      MD059895
     C+       DKMECN = :#COTT1 and DKMECS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     '98'          #1MEUN            2                        MD059895
     C                   EXSR      INSMEXC                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'GLC2000'     #COTT
     C                   MOVEL     '00001'       #DSEQ
     C                   MOVEL     'MCCF690'     #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @MEXCL3                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DKCOTT                                     MD059895
     C**********         MOVEL     #DSEQ         DKCSEQ                                     MD059895
     C**********         MOVEL     '98'          DKMEUN                                     MD059895
     C**********         MOVEL     #COTT1        DKMECN                                     MD059895
     C**********         MOVEL     #DSEQ1        DKMECS                                     MD059895
     C**********         WRITE     @MEXCL3                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBMEXC                                                                        MD059895
     C+ from CBMEXJW0                                                                       MD059895
     C+ where DKCOTT = :#COTT and DKCSEQ = :#DSEQ  and                                      MD059895
     C+       DKMECN = :#COTT1 and DKMECS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     '98'          #1MEUN            2                        MD059895
     C                   EXSR      INSMEXC                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'MCCF790'     #COTT
     C                   MOVEL     '00001'       #DSEQ
     C*****                MOVEL'SDJC400' #COTT1
     C                   MOVEL     'SDJC001'     #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @DPRLL5                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DIDSON                                     MD059895
     C**********         MOVEL     #DSEQ         DIDSOS                                     MD059895
     C**********         MOVEL     '001'         DIDRUN                                     MD059895
     C**********         MOVEL     #COTT1        DIDDON                                     MD059895
     C**********         MOVEL     #DSEQ1        DIDDOS                                     MD059895
     C**********         MOVEL     ' '           DICDST                                     MD059895
     C**********         WRITE     @DPRLL5                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBDPRL                                                                        MD059895
     C+ from CBDPRJW0                                                                       MD059895
     C+ where DIDSON = :#COTT and DIDSOS = :#DSEQ  and                                      MD059895
     C+       DIDDON = :#COTT1 and DIDDOS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CDTS            1                        MD059895
     C                   MOVEL     '001'         #1DRUN            3                        MD059895
     C                   EXSR      INSDPRL                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'MCCF890'     #COTT
     C                   MOVEL     '00001'       #DSEQ
     C                   MOVEL     'MCCF790'     #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @DPRLL5                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DIDSON                                     MD059895
     C**********         MOVEL     #DSEQ         DIDSOS                                     MD059895
     C**********         MOVEL     '001'         DIDRUN                                     MD059895
     C**********         MOVEL     #COTT1        DIDDON                                     MD059895
     C**********         MOVEL     #DSEQ1        DIDDOS                                     MD059895
     C**********         MOVEL     ' '           DICDST                                     MD059895
     C**********         WRITE     @DPRLL5                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBDPRL                                                                        MD059895
     C+ from CBDPRJW0                                                                       MD059895
     C+ where DIDSON = :#COTT and DIDSOS = :#DSEQ  and                                      MD059895
     C+       DIDDON = :#COTT1 and DIDDOS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CDTS            1                        MD059895
     C                   MOVEL     '001'         #1DRUN            3                        MD059895
     C                   EXSR      INSDPRL                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
      ** Reactivate coding only if TFJ008 is installed at Bank
     C*****                MOVEL*BLANKS   #COTT
     C*****                MOVEL*BLANKS   #COTT1
     C*****                MOVEL'MCCF890' #COTT
     C*****                MOVEL'00001'   #DSEQ
     C*****                MOVEL'SDJC430' #COTT1
     C*****                MOVEL'00001'   #DSEQ1
     C*****      KCBPR     CHAIN@DPRLL5              10
     C*****      *IN10     IFEQ '1'
     C*****                MOVEL#COTT     DIDSON
     C*****                MOVEL#DSEQ     DIDSOS
     C*****                MOVEL'900'     DIDRUN
     C*****                MOVEL#COTT1    DIDDON
     C*****                MOVEL#DSEQ1    DIDDOS
     C*****                MOVEL' '       DICDST
     C*****                WRITE@DPRLL5
     C*****                ENDIF
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'MCCF890'     #COTT
     C                   MOVEL     '00001'       #DSEQ
     C*****                MOVEL'SDJC400' #COTT1
     C                   MOVEL     'SDJC001'     #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @DPRLL5                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DIDSON                                     MD059895
     C**********         MOVEL     #DSEQ         DIDSOS                                     MD059895
     C**********         MOVEL     '901'         DIDRUN                                     MD059895
     C**********         MOVEL     #COTT1        DIDDON                                     MD059895
     C**********         MOVEL     #DSEQ1        DIDDOS                                     MD059895
     C**********         MOVEL     ' '           DICDST                                     MD059895
     C**********         WRITE     @DPRLL5                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBDPRL                                                                        MD059895
     C+ from CBDPRJW0                                                                       MD059895
     C+ where DIDSON = :#COTT and DIDSOS = :#DSEQ  and                                      MD059895
     C+       DIDDON = :#COTT1 and DIDDOS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CDTS            1                        MD059895
     C                   MOVEL     '901'         #1DRUN            3                        MD059895
     C                   EXSR      INSDPRL                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'MCC84'       #COTT
     C                   MOVEL     '10001'       #DSEQ
     C                   MOVEL     'MCCF890'     #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @DPRLL5                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DIDSON                                     MD059895
     C**********         MOVEL     #DSEQ         DIDSOS                                     MD059895
     C**********         MOVEL     '901'         DIDRUN                                     MD059895
     C**********         MOVEL     #COTT1        DIDDON                                     MD059895
     C**********         MOVEL     #DSEQ1        DIDDOS                                     MD059895
     C**********         MOVEL     ' '           DICDST                                     MD059895
     C**********         WRITE     @DPRLL5                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBDPRL                                                                        MD059895
     C+ from CBDPRJW0                                                                       MD059895
     C+ where DIDSON = :#COTT and DIDSOS = :#DSEQ  and                                      MD059895
     C+       DIDDON = :#COTT1 and DIDDOS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CDTS            1                        MD059895
     C                   MOVEL     '901'         #1DRUN            3                        MD059895
     C                   EXSR      INSDPRL                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'NDSSTART'    #COTT
     C                   MOVEL     '00001'       #DSEQ
     C                   MOVEL     'MCC84'       #COTT1
     C                   MOVEL     '10001'       #DSEQ1
     C*****KCBPR         CHAIN     @DPRLL5                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DIDSON                                     MD059895
     C**********         MOVEL     #DSEQ         DIDSOS                                     MD059895
     C**********         MOVEL     '901'         DIDRUN                                     MD059895
     C**********         MOVEL     #COTT1        DIDDON                                     MD059895
     C**********         MOVEL     #DSEQ1        DIDDOS                                     MD059895
     C**********         MOVEL     ' '           DICDST                                     MD059895
     C**********         WRITE     @DPRLL5                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBDPRL                                                                        MD059895
     C+ from CBDPRJW0                                                                       MD059895
     C+ where DIDSON = :#COTT and DIDSOS = :#DSEQ  and                                      MD059895
     C+       DIDDON = :#COTT1 and DIDDOS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CDTS            1                        MD059895
     C                   MOVEL     '901'         #1DRUN            3                        MD059895
     C                   EXSR      INSDPRL                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'MCCF990'     #COTT
     C                   MOVEL     '00001'       #DSEQ
     C                   MOVEL     'GLC42'       #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @DPRLL5                            10
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DIDSON                                     MD059895
     C**********         MOVEL     #DSEQ         DIDSOS                                     MD059895
     C**********         MOVEL     '001'         DIDRUN                                     MD059895
     C**********         MOVEL     #COTT1        DIDDON                                     MD059895
     C**********         MOVEL     #DSEQ1        DIDDOS                                     MD059895
     C**********         MOVEL     ' '           DICDST                                     MD059895
     C**********         WRITE     @DPRLL5                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBDPRL                                                                        MD059895
     C+ from CBDPRJW0                                                                       MD059895
     C+ where DIDSON = :#COTT and DIDSOS = :#DSEQ  and                                      MD059895
     C+       DIDDON = :#COTT1 and DIDDOS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CDTS            1                        MD059895
     C                   MOVEL     '001'         #1DRUN            3                        MD059895
     C                   EXSR      INSDPRL                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     TXT(7)        #COTT
     C                   MOVEL     '00001'       #DSEQ
     C                   MOVEL     'MCCF990'     #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @DPRLL5                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DIDSON                                     MD059895
     C**********         MOVEL     #DSEQ         DIDSOS                                     MD059895
     C**********         MOVEL     '900'         DIDRUN                                     MD059895
     C**********         MOVEL     #COTT1        DIDDON                                     MD059895
     C**********         MOVEL     #DSEQ1        DIDDOS                                     MD059895
     C**********         MOVEL     ' '           DICDST                                     MD059895
     C**********         WRITE     @DPRLL5                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBDPRL                                                                        MD059895
     C+ from CBDPRJW0                                                                       MD059895
     C+ where DIDSON = :#COTT and DIDSOS = :#DSEQ  and                                      MD059895
     C+       DIDDON = :#COTT1 and DIDDOS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     *BLANKS       #1CDTS            1                        MD059895
     C                   MOVEL     '900'         #1DRUN            3                        MD059895
     C                   EXSR      INSDPRL                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'MCCF990'     #COTT
     C                   MOVEL     '00001'       #DSEQ
     C                   MOVEL     'GLC2000'     #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @MEXCL3                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DKCOTT                                     MD059895
     C**********         MOVEL     #DSEQ         DKCSEQ                                     MD059895
     C**********         MOVEL     '99'          DKMEUN                                     MD059895
     C**********         MOVEL     #COTT1        DKMECN                                     MD059895
     C**********         MOVEL     #DSEQ1        DKMECS                                     MD059895
     C**********         WRITE     @MEXCL3                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBMEXC                                                                        MD059895
     C+ from CBMEXJW0                                                                       MD059895
     C+ where DKCOTT = :#COTT and DKCSEQ = :#DSEQ  and                                      MD059895
     C+       DKMECN = :#COTT1 and DKMECS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     '99'          #1MEUN            2                        MD059895
     C                   EXSR      INSMEXC                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   MOVEL     *BLANKS       #COTT
     C                   MOVEL     *BLANKS       #COTT1
     C                   MOVEL     'GLC2000'     #COTT
     C                   MOVEL     '00001'       #DSEQ
     C                   MOVEL     'MCCF990'     #COTT1
     C                   MOVEL     '00001'       #DSEQ1
     C*****KCBPR         CHAIN     @MEXCL3                            10                    MD059895
     C******IN10         IFEQ      '1'                                                      MD059895
     C**********         MOVEL     #COTT         DKCOTT                                     MD059895
     C**********         MOVEL     #DSEQ         DKCSEQ                                     MD059895
     C**********         MOVEL     '99'          DKMEUN                                     MD059895
     C**********         MOVEL     #COTT1        DKMECN                                     MD059895
     C**********         MOVEL     #DSEQ1        DKMECS                                     MD059895
     C**********         WRITE     @MEXCL3                                                  MD059895
     C**********         ENDIF                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ SELECT *                                                                            MD059895
     C+ into :CBMEXC                                                                        MD059895
     C+ from CBMEXJW0                                                                       MD059895
     C+ where DKCOTT = :#COTT and DKCSEQ = :#DSEQ  and                                      MD059895
     C+       DKMECN = :#COTT1 and DKMECS = :#DSEQ1                                         MD059895
     C/END-EXEC                                                                             MD059895
     C                   IF        SQLCODE = 100                                            MD059895
     C                   MOVEL     '99'          #1MEUN            2                        MD059895
     C                   EXSR      INSMEXC                                                  MD059895
     C                   ENDIF                                                              MD059895
      *
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *----------------------------------------------------------------                     MD059895
     C     INSSARO       BEGSR                                                              MD059895
                                                                                            MD059895
     C/EXEC SQL                                                                             MD059895
     C+ insert into SCSROBTD                                                                MD059895
     C+ (                                                                                   MD059895
     C+   AFSARN                                                                            MD059895
     C+ , AFOBNM                                                                            MD059895
     C+ , AFOBTP                                                                            MD059895
     C+ , AFOBAT                                                                            MD059895
     C+ , AFAVAL                                                                            MD059895
     C+ , AFOBTX                                                                            MD059895
     C+ , AFLCD                                                                             MD059895
     C+ , AFTYLC                                                                            MD059895
     C+ , AFMODE                                                                            MD059895
     C+ )                                                                                   MD059895
     C+ Values                                                                              MD059895
     C+ (                                                                                   MD059895
     C+   :#SARN                                                                            MD059895
     C+ , :#OBNM                                                                            MD059895
     C+ , :#OBTP                                                                            MD059895
     C+ , 'PRTF'                                                                            MD059895
     C+ , 'Y'                                                                               MD059895
     C+ , :#OBTX                                                                            MD059895
     C+ , :BJRDNB                                                                           MD059895
     C+ , 'I'                                                                               MD059895
     C+ , 'B'                                                                               MD059895
     C+ )                                                                                   MD059895
     C/END-EXEC                                                                             MD059895
                                                                                            MD059895
     C/EXEC SQL                                                                             MD059895
     C+ insert into SCSROXTD                                                                MD059895
     C+ (                                                                                   MD059895
     C+   AFSARN                                                                            MD059895
     C+ , AFOBNM                                                                            MD059895
     C+ , AFOBTP                                                                            MD059895
     C+ , AFOBAT                                                                            MD059895
     C+ , AFAVAL                                                                            MD059895
     C+ , AFOBTX                                                                            MD059895
     C+ , AFLCD                                                                             MD059895
     C+ , AFTYLC                                                                            MD059895
     C+ , AFMODE                                                                            MD059895
     C+ )                                                                                   MD059895
     C+ Values                                                                              MD059895
     C+ (                                                                                   MD059895
     C+   :#SARN                                                                            MD059895
     C+ , :#OBNM                                                                            MD059895
     C+ , :#OBTP                                                                            MD059895
     C+ , 'PRTF'                                                                            MD059895
     C+ , 'Y'                                                                               MD059895
     C+ , :#OBTX                                                                            MD059895
     C+ , :BJRDNB                                                                           MD059895
     C+ , 'I'                                                                               MD059895
     C+ , 'B'                                                                               MD059895
     C+ )                                                                                   MD059895
     C/END-EXEC                                                                             MD059895
                                                                                            MD059895
     C                   ENDSR                                                              MD059895
      /EJECT                                                                                MD059895
      *----------------------------------------------------------------                     MD059895
     C     INSSARC       BEGSR                                                              MD059895
                                                                                            MD059895
     C/EXEC SQL                                                                             MD059895
     C+ insert into SCSRCBTD                                                                MD059895
     C+ (                                                                                   MD059895
     C+   ACSARN                                                                            MD059895
     C+ , ACCOTT                                                                            MD059895
     C+ , ACCSEQ                                                                            MD059895
     C+ , ACAVAL                                                                            MD059895
     C+ , ACTYLC                                                                            MD059895
     C+ , ACLCD                                                                             MD059895
     C+ , ACMODE                                                                            MD059895
     C+ )                                                                                   MD059895
     C+ Values                                                                              MD059895
     C+ (                                                                                   MD059895
     C+   :#SARN                                                                            MD059895
     C+ , :#COTT1                                                                           MD059895
     C+ , :#CSEQ1                                                                           MD059895
     C+ , 'Y'                                                                               MD059895
     C+ , 'I'                                                                               MD059895
     C+ , :BJRDNB                                                                           MD059895
     C+ , 'B'                                                                               MD059895
     C+ )                                                                                   MD059895
     C/END-EXEC                                                                             MD059895
                                                                                            MD059895
     C/EXEC SQL                                                                             MD059895
     C+ insert into SCSRCXTD                                                                MD059895
     C+ (                                                                                   MD059895
     C+   ACSARN                                                                            MD059895
     C+ , ACCOTT                                                                            MD059895
     C+ , ACCSEQ                                                                            MD059895
     C+ , ACAVAL                                                                            MD059895
     C+ , ACTYLC                                                                            MD059895
     C+ , ACLCD                                                                             MD059895
     C+ , ACMODE                                                                            MD059895
     C+ )                                                                                   MD059895
     C+ Values                                                                              MD059895
     C+ (                                                                                   MD059895
     C+   :#SARN                                                                            MD059895
     C+ , :#COTT1                                                                           MD059895
     C+ , :#CSEQ1                                                                           MD059895
     C+ , 'Y'                                                                               MD059895
     C+ , 'I'                                                                               MD059895
     C+ , :BJRDNB                                                                           MD059895
     C+ , 'B'                                                                               MD059895
     C+ )                                                                                   MD059895
     C/END-EXEC                                                                             MD059895
                                                                                            MD059895
     C                   ENDSR                                                              MD059895
      /EJECT                                                                                MD059895
      *----------------------------------------------------------------                     MD059895
     C     INSDPRL       BEGSR                                                              MD059895
                                                                                            MD059895
     C/EXEC SQL                                                                             MD059895
     C+ insert into CBDPRBTD                                                                MD059895
     C+ (                                                                                   MD059895
     C+   DIDSON                                                                            MD059895
     C+ , DIDSOS                                                                            MD059895
     C+ , DIDRUN                                                                            MD059895
     C+ , DIDDON                                                                            MD059895
     C+ , DIDDOS                                                                            MD059895
     C+ , DICDST                                                                            MD059895
     C+ , DIMODE                                                                            MD059895
     C+ )                                                                                   MD059895
     C+ Values                                                                              MD059895
     C+ (                                                                                   MD059895
     C+   :#COTT                                                                            MD059895
     C+ , :#DSEQ                                                                            MD059895
     C+ , :#1DRUN                                                                           MD059895
     C+ , :#COTT1                                                                           MD059895
     C+ , :#DSEQ1                                                                           MD059895
     C+ , :#1CDTS                                                                           MD059895
     C+ , 'B'                                                                               MD059895
     C+ )                                                                                   MD059895
     C/END-EXEC                                                                             MD059895
                                                                                            MD059895
     C/EXEC SQL                                                                             MD059895
     C+ insert into CBDPRXTD                                                                MD059895
     C+ (                                                                                   MD059895
     C+   DIDSON                                                                            MD059895
     C+ , DIDSOS                                                                            MD059895
     C+ , DIDRUN                                                                            MD059895
     C+ , DIDDON                                                                            MD059895
     C+ , DIDDOS                                                                            MD059895
     C+ , DIMODE                                                                            MD059895
     C+ )                                                                                   MD059895
     C+ Values                                                                              MD059895
     C+ (                                                                                   MD059895
     C+   :#COTT                                                                            MD059895
     C+ , :#DSEQ                                                                            MD059895
     C+ , :#1DRUN                                                                           MD059895
     C+ , :#COTT1                                                                           MD059895
     C+ , :#DSEQ1                                                                           MD059895
     C+ , 'B'                                                                               MD059895
     C+ )                                                                                   MD059895
     C/END-EXEC                                                                             MD059895
                                                                                            MD059895
     C                   ENDSR                                                              MD059895
      /EJECT                                                                                MD059895
      *----------------------------------------------------------------                     MD059895
     C     INSMEXC       BEGSR                                                              MD059895
                                                                                            MD059895
     C/EXEC SQL                                                                             MD059895
     C+ insert into CBMEXBTD                                                                MD059895
     C+ (                                                                                   MD059895
     C+   DKCOTT                                                                            MD059895
     C+ , DKCSEQ                                                                            MD059895
     C+ , DKMEUN                                                                            MD059895
     C+ , DKMECN                                                                            MD059895
     C+ , DKMECS                                                                            MD059895
     C+ , DKMODE                                                                            MD059895
     C+ )                                                                                   MD059895
     C+ Values                                                                              MD059895
     C+ (                                                                                   MD059895
     C+   :#COTT                                                                            MD059895
     C+ , :#DSEQ                                                                            MD059895
     C+ , :#1MEUN                                                                           MD059895
     C+ , :#COTT1                                                                           MD059895
     C+ , :#DSEQ1                                                                           MD059895
     C+ , 'B'                                                                               MD059895
     C+ )                                                                                   MD059895
     C/END-EXEC                                                                             MD059895
                                                                                            MD059895
     C/EXEC SQL                                                                             MD059895
     C+ insert into CBMEXXTD                                                                MD059895
     C+ (                                                                                   MD059895
     C+   DKCOTT                                                                            MD059895
     C+ , DKCSEQ                                                                            MD059895
     C+ , DKMEUN                                                                            MD059895
     C+ , DKMECN                                                                            MD059895
     C+ , DKMECS                                                                            MD059895
     C+ , DKMODE                                                                            MD059895
     C+ )                                                                                   MD059895
     C+ Values                                                                              MD059895
     C+ (                                                                                   MD059895
     C+   :#COTT                                                                            MD059895
     C+ , :#DSEQ                                                                            MD059895
     C+ , :#1MEUN                                                                           MD059895
     C+ , :#COTT1                                                                           MD059895
     C+ , :#DSEQ1                                                                           MD059895
     C+ , 'B'                                                                               MD059895
     C+ )                                                                                   MD059895
     C/END-EXEC                                                                             MD059895
                                                                                            MD059895
     C                   ENDSR                                                              MD059895
      /EJECT                                                                                MD059895
      *----------------------------------------------------------------                     MD059895
     C     INSCMPN       BEGSR                                                              MD059895
     C/EXEC SQL                                                                             MD059895
     C+ insert into CBCMPBTD                                                                MD059895
     C+ (                                                                                   MD059895
     C+   DHCOTT                                                                            MD059895
     C+ , DHCSEQ                                                                            MD059895
     C+ , DHCSTS                                                                            MD059895
     C+ , DHCSHP                                                                            MD059895
     C+ , DHCEPY                                                                            MD059895
     C+ , DHCTSL                                                                            MD059895
     C+ , DHCFOB                                                                            MD059895
     C+ , DHCTXT                                                                            MD059895
     C+ , DHCPRM                                                                            MD059895
     C+ , DHCRQD                                                                            MD059895
     C+ , DHCMOD                                                                            MD059895
     C+ , DHCEMI                                                                            MD059895
     C+ , DHCRES                                                                            MD059895
     C+ , DHCODP                                                                            MD059895
     C+ , DHCMEF                                                                            MD059895
     C+ , DHCFRQ                                                                            MD059895
     C+ , DHCSDE                                                                            MD059895
     C+ , DHCSTI                                                                            MD059895
     C+ , DHCEDE                                                                            MD059895
     C+ , DHCETI                                                                            MD059895
     C+ , DHCHTB                                                                            MD059895
     C+ , DHCHTA                                                                            MD059895
     C+ , DHCFAL                                                                            MD059895
     C+ , DHEODT                                                                            MD059895
     C+ , DHEOMT                                                                            MD059895
     C+ , DHBOMT                                                                            MD059895
     C+ , DHEOYT                                                                            MD059895
     C+ , DHEODC                                                                            MD059895
     C+ , DHEOMC                                                                            MD059895
     C+ , DHBOMC                                                                            MD059895
     C+ , DHEOYC                                                                            MD059895
     C+ , DHABIC                                                                            MD059895
     C+ , DHCBSN                                                                            MD059895
     C+ , DHTASK                                                                            MD059895
     C+ , DHTSNO                                                                            MD059895
     C+ , DHMODE                                                                            MD059895
     C+ , DHCPCA                                                                            MD059895
     C+ , DHLOGD                                                                            MD059895
     C+ )                                                                                   MD059895
     C+ Values                                                                              MD059895
     C+ (                                                                                   MD059895
     C+   :#COTT1                                                                           MD059895
     C+ , :#DSEQ1                                                                           MD059895
     C+ , :#1CSTS                                                                           MD059895
     C+ , :#1CSHP                                                                           MD059895
     C+ , :#1CEPY                                                                           MD059895
     C+ , :#1CTSL                                                                           MD059895
     C+ , :#1CFOB                                                                           MD059895
     C+ , :#1CTXT                                                                           MD059895
     C+ , :#1CPRM                                                                           MD059895
     C+ , :#1CRQD                                                                           MD059895
     C+ , :#1CMOD                                                                           MD059895
     C+ , :#1CEMI                                                                           MD059895
     C+ , :#1CRES                                                                           MD059895
     C+ , :#1CODP                                                                           MD059895
     C+ , :#1CMEF                                                                           MD059895
     C+ , :#1CFRQ                                                                           MD059895
     C+ , :#1CSDE                                                                           MD059895
     C+ , :#1CSTI                                                                           MD059895
     C+ , :#1CEDE                                                                           MD059895
     C+ , :#1CETI                                                                           MD059895
     C+ , :#1CHTB                                                                           MD059895
     C+ , :#1CHTA                                                                           MD059895
     C+ , :#1CFAL                                                                           MD059895
     C+ , :#1EODT                                                                           MD059895
     C+ , :#1EOMT                                                                           MD059895
     C+ , :#1BOMT                                                                           MD059895
     C+ , :#1EOYT                                                                           MD059895
     C+ , :#1EODC                                                                           MD059895
     C+ , :#1EOMC                                                                           MD059895
     C+ , :#1BOMC                                                                           MD059895
     C+ , :#1EOYC                                                                           MD059895
     C+ , :#1ABIC                                                                           MD059895
     C+ , :#1CBSN                                                                           MD059895
     C+ , :#1TASK                                                                           MD059895
     C+ , :#1TSNO                                                                           MD059895
     C+ , 'B'                                                                               MD059895
     C+ , 'Y'                                                                               MD059895
     C+ , 'N'                                                                               MD059895
     C+ )                                                                                   MD059895
     C/END-EXEC                                                                             MD059895
     C/EXEC SQL                                                                             MD059895
     C+ insert into CBCMPXTD                                                                MD059895
     C+ (                                                                                   MD059895
     C+   DHCOTT                                                                            MD059895
     C+ , DHCSEQ                                                                            MD059895
     C+ , DHCSHP                                                                            MD059895
     C+ , DHCEPY                                                                            MD059895
     C+ , DHCTSL                                                                            MD059895
     C+ , DHCPRM                                                                            MD059895
     C+ , DHCEMI                                                                            MD059895
     C+ , DHCODP                                                                            MD059895
     C+ , DHCMEF                                                                            MD059895
     C+ , DHCFRQ                                                                            MD059895
     C+ , DHCSDE                                                                            MD059895
     C+ , DHCSTI                                                                            MD059895
     C+ , DHCEDE                                                                            MD059895
     C+ , DHCETI                                                                            MD059895
     C+ , DHEODT                                                                            MD059895
     C+ , DHEOMT                                                                            MD059895
     C+ , DHBOMT                                                                            MD059895
     C+ , DHEOYT                                                                            MD059895
     C+ , DHEODC                                                                            MD059895
     C+ , DHEOMC                                                                            MD059895
     C+ , DHBOMC                                                                            MD059895
     C+ , DHEOYC                                                                            MD059895
     C+ , DHABIC                                                                            MD059895
     C+ , DHTSNO                                                                            MD059895
     C+ , DHMODE                                                                            MD059895
     C+ , DHCPCA                                                                            MD059895
     C+ , DHLOGD                                                                            MD059895
     C+ )                                                                                   MD059895
     C+ Values                                                                              MD059895
     C+ (                                                                                   MD059895
     C+   :#COTT1                                                                           MD059895
     C+ , :#DSEQ1                                                                           MD059895
     C+ , :#1CSTS                                                                           MD059895
     C+ , :#1CEPY                                                                           MD059895
     C+ , :#1CTSL                                                                           MD059895
     C+ , :#1CPRM                                                                           MD059895
     C+ , :#1CEMI                                                                           MD059895
     C+ , :#1CODP                                                                           MD059895
     C+ , :#1CMEF                                                                           MD059895
     C+ , :#1CFRQ                                                                           MD059895
     C+ , :#1CSDE                                                                           MD059895
     C+ , :#1CSTI                                                                           MD059895
     C+ , :#1CEDE                                                                           MD059895
     C+ , :#1CETI                                                                           MD059895
     C+ , :#1EODT                                                                           MD059895
     C+ , :#1EOMT                                                                           MD059895
     C+ , :#1BOMT                                                                           MD059895
     C+ , :#1EOYT                                                                           MD059895
     C+ , :#1EODC                                                                           MD059895
     C+ , :#1EOMC                                                                           MD059895
     C+ , :#1BOMC                                                                           MD059895
     C+ , :#1EOYC                                                                           MD059895
     C+ , :#1ABIC                                                                           MD059895
     C+ , :#1TSNO                                                                           MD059895
     C+ , 'B'                                                                               MD059895
     C+ , 'Y'                                                                               MD059895
     C+ , 'N'                                                                               MD059895
     C+ )                                                                                   MD059895
     C/END-EXEC                                                                             MD059895
     C                   ENDSR                                                              MD059895
      *----------------------------------------------------------------
      *  *PSSR  Program error subroutine
      *----------------------------------------------------------------
     C     *PSSR         BEGSR
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   RETURN
     C                   ENDSR
      /EJECT
**CTDATA TXT
Management Accounts Automatic Balance UPdate
Management Account Balances
Midas MC EML108 Accounts Balances Report                                                  EML108A
Midas MC Automatic Balance Update
Midas MC Management Account Balances
'10001'
COBFINISH
Midas MC Account Balances
Midas MC Account Daily Balances
Midas MC EML108 Average Balances File Maintenance                                         EML108A
Midas MC GE-XB Postings Update
Midas MC Average Balance Calculation
**CTDATA CPY@
(c)  Finastra International Limited 2009
