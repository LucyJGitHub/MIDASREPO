     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FD End of Day - Split Jrn for DRS Audit Rep')
/*OVRF*  OVRDBF JRNWORK QADSPJRN                                      *   E21873
     F*****************************************************************
     F*                                                               *
     F*  Midas - Standing Data Module
     F*                                                               *
     F*     FD0510 - Split Journal dump into audit files, one audit   *
     F*              file per Audit Report, and split into fields     *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8891            Date 12Oct05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 21Aug01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                    S01319             DATE   24SEP91          *
     F*                    S01328             DATE   14FEB91          *
     F*                    E18977             DATE   23AUG90          *
     F*                    E21873             DATE   07MAY90          *
     F*                    E19122             DATE   20FEB90          *
     F*                    E12304             DATE   17/03/88         *
     F*                    E12311             DATE   08/03/88         *
     F*                    S01145             DATE   23/11/87         *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
     F*     BUG8891 - M+ ref DL1956 & DL1950 Single IRS & FRA         *
     F*               revaluation reports can not be found in         *
     F*               intellistor or AS400 during COB                 *
     F*     CPK014 - Packaging for Release 4.  IBM outfile QADSPJRN   *
     F*              has field JOINCDAT, the name of which is too     *
     F*              long for OPM.  Converted program to ILE.         *
     F*     S01319 - Remove redundant processing                      *
     F*     S01328 - FRA/IRS REVALUATION - SPLIT FRA AND IRS ENTRIES  *
     F*              INTO FDAUDNPP AND FDAUDOPP RESPECTIVELY.         *
     F*     E18977 - RECOMPILED DUE TO CHANGES IN MMAUDGPP.           *   E18977
     F*     E21873 - OVERIDE TO SYSTEM FILE NEEDED FOR CREATING PGM   *   E21873
     F*     E19122 - KEY FIELDS CCY & NOSN SHOULD BE REPEATED IN FILE *   S01145
     F*              FDAUDCPP, FOR USE BY PROG FD0360
     F*     E12304 - DATA STRUCTURE REDEFINES XXDULP TO XXDLUX(ALPHA) *   S01145
     F*              WHEN CHANGES HAVE BEEN MADE TO FILES THIS        *
     F*              REDEFINE HAS BEEN MISSED THEREFORE XXDLUX        *
     F*              REDEFINES THE WRONG FIELD.                       *
     F*     E12311 - FILE MMDOLMPP, LINE 300, REPLACED BY FILE        *   S01145
     F*              MMLMCYPP                                         *
     F*     S01145 - ADDITION OF ARBITRAGE PROCESSING                 *   S01145
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  Journal, Selected record types previously dumped to disk     *
     F*****************************************************************
     FJRNWORK   IP   E             DISK
     F*                                                               *
     F*  Output one file for each audit report                        *
     F*                                                               *
     F*ABAUDCPPO   E                    DISK                       S01145 S01319
     F*****       QJORDJE                           KRENAMEABACFM  S01145 S01319
     F*ABAUDDPPO   E                    DISK                       S01145 S01319
     F*****       QJORDJE                           KRENAMEABADFM  S01145 S01319
     F*ABAUDEPPO   E                    DISK                       S01145 S01319
     F*****       QJORDJE                           KRENAMEABAEFM  S01145 S01319
     F*FDAUDAPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDAFMT        S01319
     F*FDAUDBPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDBFMT        S01319
     F*FDAUDCPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDCFMT        S01319
     F*FDAUDDPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDDFMT        S01319
     FFDAUDEPP  O    E             DISK
     F                                     RENAME(QJORDJE:AUDEFMT)
     FFDAUDFPP  O    E             DISK
     F                                     RENAME(QJORDJE:AUDFFMT)
     F*FDAUDGPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDGFMT        S01319
     F*FDAUDHPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDHFMT        S01319
     F*FDAUDIPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDIFMT        S01319
     F*FDAUDJPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDJFMT        S01319
     F*FDAUDKPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDKFMT        S01319
     FFXAUDAPP  O    E             DISK
     F                                     RENAME(QJORDJE:AUDLFMT)
     F*FXAUDBPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDMFMT        S01319
     FFXAUDCPP  O    E             DISK
     F                                     RENAME(QJORDJE:AUDNFMT)
     F*FXAUDDPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDOFMT        S01319
     FFXAUDEPP  O    E             DISK
     F                                     RENAME(QJORDJE:AUDPFMT)
     F*FXAUDFPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDQFMT        S01319
     F*FXAUDGPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDRFMT        S01319
     FMMAUDAPP  O    E             DISK
     F                                     RENAME(QJORDJE:AUDSFMT)
     F*MMAUDBPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDTFMT        S01319
     FMMAUDCPP  O    E             DISK
     F                                     RENAME(QJORDJE:AUDUFMT)
     F*MMAUDDPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDVFMT        S01319
     FMMAUDEPP  O    E             DISK
     F                                     RENAME(QJORDJE:AUDWFMT)
     F*MMAUDFPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDXFMT        S01319
     F*MMAUDGPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEAUDYFMT        S01319
     FFDAUDLPP  O    E             DISK
     F                                     RENAME(QJORDJE:AUDZFMT)
     F*FDAUDMPPO   E                    DISK                              S01319
     F*****       QJORDJE                           KRENAMEBUDAFMT        S01319
     FFDAUDNPP  O    E             DISK                                         S01328
     F                                     RENAME(QJORDJE:BUDBFMT)              S01328
     F***FDAUDOPP  O    E             DISK                                            S01328 BUG8891
     FFDAUDOPD  O    E             DISK                                                      BUG8891
     F                                     RENAME(QJORDJE:BUDCFMT)              S01328
     D*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D/EJECT
     D FDJRN         E DS                  EXTNAME(JRNWORK)
     D  JOBAS                  1    125
     D  CCY                  134    136                                         E19122
     D  NOSN                 137    138                                         E19122
     D  CSNM                 244    253                                         E19122
     D*                                                               *
     D*  Load the field layouts from external data structures         *
     D*                                                               *
     D*ABAUDC    E DSABAUDCPP                                      S01145 S01319
     D*****                                   1 125 JKBAS          S01145 S01319
     D*****                                 126 325 JKESD          S01145 S01319
     D*****                                 129 130 JKDLUX         S01145 S01319
     D*ABAUDD    E DSABAUDDPP                                      S01145 S01319
     D*****                                   1 125 JLBAS          S01145 S01319
     D*****                                 126 325 JLESD          S01145 S01319
     D*****                                 129 130 JLDLUX         S01145 S01319
     D*ABAUDE    E DSABAUDEPP                                      S01145 S01319
     D*****                                   1 125 JNBAS          S01145 S01319
     D*****                                 126 325 JNESD          S01145 S01319
     D*****                                 129 130 JNDLUX         S01145 S01319
     D*FDAUDA    E DSFDAUDAPP                                             S01319
     D*****                                   1 125 AABAS                 S01319
     D*****                                 126 325 AAESD                 S01319
     D*****                                 129 130 AADLUX                S01319
     D*FDAUDB    E DSFDAUDBPP                                             S01319
     D*****                                   1 125 ABBAS                 S01319
     D*****                                 126 325 ABESD                 S01319
     D*****                                 129 130 ABDLUX                S01319
     D*FDAUDC    E DSFDAUDCPP                                             S01319
     D*****                                   1 125 ACBAS                 S01319
     D*****                                 126 325 ACESD                 S01319
     D***************                       224 225 ACDLUX                E12304
     D*****                                 227 228 ACDLUX         E12304 S01319
     D*****                                 244 246 ACCY           E19122 S01319
     D*****                                 247 248 ANOSN          E19122 S01319
     D*****                                 249 258 ACSNM          E19122 S01319
     D*FDAUDD    E DSFDAUDDPP                                             S01319
     D*****                                   1 125 ADBAS                 S01319
     D*****                                 126 325 ADESD                 S01319
     D*****                                 129 130 ADDLUX                S01319
     D FDAUDE        E DS                  EXTNAME(FDAUDEPP)
     D  AEBAS                  1    125
     D  AEESD                126    325
     D  AEDLUX               129    130
     D FDAUDF        E DS                  EXTNAME(FDAUDFPP)
     D  AFBAS                  1    125
     D  AFESD                126    325
     D  AFDLUX               129    130
     D*FDAUDG    E DSFDAUDGPP                                             S01319
     D*****                                   1 125 AGBAS                 S01319
     D*****                                 126 325 AGESD                 S01319
     D***************                       224 225 AGDLUX                E12304
     D*****                                 227 228 AGDLUX         E12304 S01319
     D*FDAUDH    E DSFDAUDHPP                                             S01319
     D*****                                   1 125 AHBAS                 S01319
     D*****                                 126 325 AHESD                 S01319
     D*****                                 129 130 AHDLUX                S01319
     D*FDAUDI    E DSFDAUDIPP                                             S01319
     D*****                                   1 125 AIBAS                 S01319
     D*****                                 126 325 AIESD                 S01319
     D*************                         224 225 AIDLUX                E12304
     D*****                                 227 228 AIDLUX         E12304 S01319
     D*FDAUDJ    E DSFDAUDJPP                                             S01319
     D*****                                   1 125 AJBAS                 S01319
     D*****                                 126 325 AJESD                 S01319
     D*****                                 227 228 AJDLUX                S01319
     D*FDAUDK    E DSFDAUDKPP                                             S01319
     D*****                                   1 125 AKBAS                 S01319
     D*****                                 126 325 AKESD                 S01319
     D*****                                 168 174 AKHBEX                S01319
     D FDAUDL        E DS                  EXTNAME(FDAUDLPP)
     D  ALBAS                  1    125
     D  ALESD                126    325
     D  ALDLUX               129    130
     D*FDAUDM    E DSFDAUDMPP                                             S01319
     D*****                                   1 125 ANBAS                 S01319
     D*****                                 126 325 ANESD                 S01319
     D********                              129 130 ANDLUX                E12304
     D*****                                 224 225 ANDLUX         E12304 S01319
     D FXAUDA        E DS                  EXTNAME(FXAUDAPP)
     D  FLBAS                  1    125
     D  FLESD                126    325
     D  FLDLUX               129    130
     D*FXAUDB    E DSFXAUDBPP                                             S01319
     D*****                                   1 125 FWBAS                 S01319
     D*****                                 126 325 FWESD                 S01319
     D*****                                 129 130 FWDLUX                S01319
     D FXAUDC        E DS                  EXTNAME(FXAUDCPP)
     D  FDBAS                  1    125
     D  FDESD                126    325
     D  FDDLUX               129    130
     D*FXAUDD    E DSFXAUDDPP                                             S01319
     D*****                                   1 125 FJBAS                 S01319
     D*****                                 126 325 FJESD                 S01319
     D*****                                 129 130 FJDLUX                S01319
     D FXAUDE        E DS                  EXTNAME(FXAUDEPP)
     D  FSBAS                  1    125
     D  FSESD                126    325
     D  FSDLUX               129    130
     D*FXAUDF    E DSFXAUDFPP                                             S01319
     D*****                                   1 125 FZBAS                 S01319
     D*****                                 126 325 FZESD                 S01319
     D*****                                 129 130 FZDLUX                S01319
     D*FXAUDG    E DSFXAUDGPP                                             S01319
     D*****                                   1 125 FYBAS                 S01319
     D*****                                 126 325 FYESD                 S01319
     D*****                                 129 130 FYDLUX                S01319
     D MMAUDA        E DS                  EXTNAME(MMAUDAPP)
     D  HABAS                  1    125
     D  HAESD                126    325
     D  HADLUX               129    130
     D*MMAUDB    E DSMMAUDBPP                                             S01319
     D*****                                   1 125 HBBAS                 S01319
     D*****                                 126 325 HBESD                 S01319
     D*****                                 129 130 HBDLUX                S01319
     D MMAUDC        E DS                  EXTNAME(MMAUDCPP)
     D  HCBAS                  1    125
     D  HCESD                126    325
     D  HCDLUX               129    130
     D*MMAUDD    E DSMMAUDDPP                                             S01319
     D*****                                   1 125 HDBAS                 S01319
     D*****                                 126 325 HDESD                 S01319
     D*****                                 129 130 HDDLUX                S01319
     D MMAUDE        E DS                  EXTNAME(MMAUDEPP)
     D  HEBAS                  1    125
     D  HEESD                126    325
     D  HEDLUX               129    130
     D*MMAUDF    E DSMMAUDFPP                                             S01319
     D*****                                   1 125 HFBAS                 S01319
     D*****                                 126 325 HFESD                 S01319
     D*****                                 129 130 HFDLUX                S01319
     D*MMAUDG    E DSMMAUDGPP                                             S01319
     D*****                                   1 125 HGBAS                 S01319
     D*****                                 126 325 HGESD                 S01319
     D*****                                 129 130 HGDLUX                S01319
     D FDAUDN        E DS                  EXTNAME(FDAUDNPP)                    S01328
     D  AMBAS                  1    125                                         S01328
     D  AMESD                126    325                                         S01328
     D  AMDLUX               176    177                                         S01328
     D***FDAUDO        E DS                  EXTNAME(FDAUDOPP)                        S01328 BUG8891
     D FDAUDO        E DS                  EXTNAME(FDAUDOPD)                                 BUG8891
     D  AOBAS                  1    125                                         S01328
     D  AOESD                126    325                                         S01328
     D  AODLUX               176    177                                         S01328
     C****************************************************************
     C*                                                              *
     C*    Mainline       DIVIDE JOURNAL INTO FILES                  *
     C*                                                              *
     C*       CALLS      : #B                                        *
     C*                                                              *
     C**
     C****************************************************************
     C                   MOVEA     CPY@          BIS@             80
     C*                                                              *
     C**
     C                   EXSR      #B
     C**
     C****************************************************************
     C*                                                              *
     C*    INDEX TO SUBROUTINES                                      *
     C*                                                              *
     C*       #B   :    Direct each journal entry to relevant file   *
     C********#BA  :    Set up FDAUDAPP                              *    S01319
     C********#BB  :    Set up FDAUDBPP                              *    S01319
     C********#BC  :    Set up FDAUDCPP                              *    S01319
     C********#BD  :    Set up FDAUDDPP                              *    S01319
     C*       #BE  :    Set up FDAUDEPP                              *
     C*       #BF  :    Set up FDAUDFPP                              *
     C********#BG  :    Set up FDAUDGPP                              *    S01319
     C********#BH  :    Set up FDAUDHPP                              *    S01319
     C********#BI  :    Set up FDAUDIPP                              *    S01319
     C********#BJ  :    Set up FDAUDJPP                              *    S01319
     C********#BK  :    Set up FDAUDKPP                              *    S01319
     C*       #BL  :    Set up FXAUDAPP                              *
     C********#BM  :    Set up FXAUDBPP                              *    S01319
     C*       #BN  :    Set up FXAUDCPP                              *
     C********#BO  :    Set up FXAUDDPP                              *    S01319
     C*       #BP  :    Set up FXAUDEPP                              *
     C********#BQ  :    Set up FXAUDFPP                              *    S01319
     C********#BR  :    Set up FXAUDGPP                              *    S01319
     C*       #BS  :    Set up MMAUDAPP                              *
     C********#BT  :    Set up MMAUDBPP                              *    S01319
     C*       #BU  :    Set up MMAUDCPP                              *
     C********#BV  :    Set up MMAUDDPP                              *    S01319
     C*       #BW  :    Set up MMAUDEPP                              *
     C********#BX  :    Set up MMAUDFPP                              *    S01319
     C********#BY  :    Set up MMAUDGPP                              *    S01319
     C*       #BZ  :    Set up FDAUDLPP                              *
     C********#BBA :    Set up FDAUDMPP                              *    S01319
     C********#BBB :    Set up ABAUDCPP                            S01145 S01319
     C********#BBC :    Set up ABAUDDPP                            S01145 S01319
     C********#BBD :    Set up ABAUDEPP                            S01145 S01319
     C*       #BBE :    Set up FDAUDNPP                              *    S01328
     C********#BBF :    Set up FDAUDOPP                              *                S01328 BUG8891
     C*       #BBF :    Set up FDAUDOPD                              *                       BUG8891
     C**
     C****************************************************************
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*    #B    DIVIDE JOURNAL INTO FILES                           *
     C*       CALLED BY  : MAINLINE                                  *
     C******  CALLS      : #BA                                       *    S01319
     C******             : #BB                                       *    S01319
     C******             : #BC                                       *    S01319
     C******             : #BD                                       *    S01319
     C*       CALLS      : #BE                                       *    S01319
     C*                  : #BF                                       *
     C******             : #BG                                       *    S01319
     C******             : #BH                                       *    S01319
     C******             : #BI                                       *    S01319
     C******             : #BJ                                       *    S01319
     C******             : #BK                                       *    S01319
     C*                  : #BL                                       *
     C******             : #BM                                       *    S01319
     C*                  : #BN                                       *
     C******             : #BO                                       *    S01319
     C*                  : #BP                                       *
     C******             : #BQ                                       *    S01319
     C******             : #BR                                       *    S01319
     C*                  : #BS                                       *
     C******             : #BT                                       *    S01319
     C*                  : #BU                                       *
     C******             : #BV                                       *    S01319
     C*                  : #BW                                       *
     C******             : #BX                                       *    S01319
     C******             : #BY                                       *    S01319
     C*                  : #BZ                                       *
     C******             : #BBA                                      *    S01319
     C******             : #BBB                                    S01145 S01319
     C******             : #BBC                                    S01145 S01319
     C******             : #BBD                                    S01145 S01319
     C*                  : #BBE                                      *    S01328
     C*                  : #BBF                                      *    S01328
     C*                                                              *
     C****************************************************************
     C**
     C     #B            BEGSR
     C**
     C*****      JOOBJ     CASEQ'FDUSSIPP'#BA                             S01319
     C*****      JOOBJ     CASEQ'FDUMODPP'#BB                             S01319
     C*****      JOOBJ     CASEQ'TABLETL '#BC                             S01319
     C*****      JOOBJ     CASEQ'FDCCCYPP'#BD                             S01319
     C     JOOBJ         CASEQ     'FDCCYPPP'    #BE
     C     JOOBJ         CASEQ     'FDLCCYPP'    #BF
     C*****      JOOBJ     CASEQ'TABLETRP'#BG                             S01319
     C*****      JOOBJ     CASEQ'FDDCOLPP'#BH                             S01319
     C*****      JOOBJ     CASEQ'TABLET2P'#BI                             S01319
     C*****      JOOBJ     CASEQ'TABTG10P'#BJ                             S01319
     C*****      JOOBJ     CASEQ'TABTG20P'#BK                             S01319
     C*
     C     JOOBJ         CASEQ     'FXDOLMPP'    #BL
     C*****      JOOBJ     CASEQ'FXSSTSPP'#BM                             S01319
     C     JOOBJ         CASEQ     'FXCDAFPP'    #BN
     C*****      JOOBJ     CASEQ'FXDLDFPP'#BO                             S01319
     C     JOOBJ         CASEQ     'FXMCOMPP'    #BP
     C*****      JOOBJ     CASEQ'FXUSERPP'#BQ                             S01319
     C*****      JOOBJ     CASEQ'FXUAUTPP'#BR                             S01319
      *
     C*****      JOOBJ     CASEQ'MMDOLMPP'#BS                             E12311
     C     JOOBJ         CASEQ     'MMLMCYPP'    #BS                                           E1231
     C*****      JOOBJ     CASEQ'MMSSTSPP'#BT                             S01319
     C     JOOBJ         CASEQ     'MMCDAFPP'    #BU
     C*****      JOOBJ     CASEQ'MMDLDFPP'#BV                             S01319
     C     JOOBJ         CASEQ     'MMMCOMPP'    #BW
     C*****      JOOBJ     CASEQ'MMUSERPP'#BX                             S01319
     C*****      JOOBJ     CASEQ'MMUAUTPP'#BY                             S01319
     C     JOOBJ         CASEQ     'FDINTRPP'    #BZ
     C*****      JOOBJ     CASEQ'TABLETKP'#BBA                            S01319
     C*****      JOOBJ     CASEQ'ABDLDFPP'#BBB                     S01145 S01319
     C*****      JOOBJ     CASEQ'ABUSERPP'#BBC                     S01145 S01319
     C*****      JOOBJ     CASEQ'ABSSTSPP'#BBD                     S01145 S01319
     C     JOOBJ         CASEQ     'DLFRARPP'    #BBE                                          S0132
     C*****JOOBJ         CASEQ     'DLIRSRPP'    #BBF                                  S0132 BUG8891
     C     JOOBJ         CASEQ     'DLSWPRPD'    #BBF                                        BUG8891
     C                   END
     C**
     C                   ENDSR
     C**
     C****************************************************************
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BA   GENERATES FDAUDAPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C*****      #BA       BEGSR                                          S01319
     C*****                MOVELJOBAS     AABAS                           S01319
     C*****                MOVELJOESD     AAESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      AADLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     AADLUP                          S01319
     C*****                Z-ADD*ZERO     AAYLUP                          S01319
     C*****                Z-ADD*ZERO     AATLUP                          S01319
     C*****                Z-ADD*ZERO     AALCD                           S01319
     C*****                Z-ADD*ZERO     AATOPD                          S01319
     C*****                Z-ADD*ZERO     AARFPD                          S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDAFMT                                   S01319
     C*****                ENDSR                                          S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BB   GENERATES FDAUDBPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C*****      #BB       BEGSR                                          S01319
     C*****                MOVELJOBAS     ABBAS                           S01319
     C*****                MOVELJOESD     ABESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      ABDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     ABDLUP                          S01319
     C*****                Z-ADD*ZERO     ABYLUP                          S01319
     C*****                Z-ADD*ZERO     ABTLUP                          S01319
     C*****                Z-ADD*ZERO     ABLCD                           S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDBFMT                                   S01319
     C*****                ENDSR                                          S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BC   GENERATES FDAUDCPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C*****      #BC       BEGSR                                          S01319
     C*****                MOVELJOBAS     ACBAS                           S01319
     C*****                MOVELJOESD     ACESD                           S01319
     C*****                MOVE CCY       ACCY                     E19122 S01319
     C*****                MOVE NOSN      ANOSN                    E19122 S01319
     C*****                MOVE CSNM      ACSNM                    E19122 S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      ACDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     ACDLUP                          S01319
     C*****                Z-ADD*ZERO     ACYLUP                          S01319
     C*****                Z-ADD*ZERO     ACTLUP                          S01319
     C*****                Z-ADD*ZERO     ACLCD                           S01319
     C*****                Z-ADD*ZERO     ACCNUM                          S01319
     C*****                Z-ADD*ZERO     ACACSQ                          S01319
     C*****                Z-ADD*ZERO     ACACOD                          S01319
     C*****                Z-ADD*ZERO     ACTNLU                          S01319
     C*****                Z-ADD*ZERO     ACNOSN                          S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDCFMT                                   S01319
     C*****                ENDSR                                          S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BD   GENERATES FDAUDDPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****      #BD       BEGSR                                          S01319
     C*****                MOVELJOBAS     ADBAS                           S01319
     C*****                MOVELJOESD     ADESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      ADDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     ADDLUP                          S01319
     C*****                Z-ADD*ZERO     ADYLUP                          S01319
     C*****                Z-ADD*ZERO     ADTLUP                          S01319
     C*****                Z-ADD*ZERO     ADLCD                           S01319
     C*****                Z-ADD*ZERO     ADCNUM                          S01319
     C*****                Z-ADD*ZERO     ADACSQ                          S01319
     C*****                Z-ADD*ZERO     ADACNO                          S01319
     C*****                Z-ADD*ZERO     ADACOD                          S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDDFMT                                   S01319
     C*****                ENDSR                                          S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*    #BE   GENERATES FDAUDEPP.                                 *
     C*       CALLED BY  : #B                                        *
     C*       CALLS      :                                           *
     C*                                                              *
     C****************************************************************
     C**
     C**
     C     #BE           BEGSR
     C                   MOVEL     JOBAS         AEBAS
     C                   MOVEL     JOESD         AEESD
     C**
     C     JOENTT        IFEQ      'DL'
     C     JOENTT        OREQ      'DR'
     C     AEDLUX        IFLT      '0'
     C                   Z-ADD     *ZERO         AEDLUP
     C                   Z-ADD     *ZERO         AEYLUP
     C                   Z-ADD     *ZERO         AETLUP
     C                   Z-ADD     *ZERO         AELCD
     C                   Z-ADD     *ZERO         AEPRD
     C                   Z-ADD     *ZERO         AEHIPT
     C                   Z-ADD     *ZERO         AELOPT
     C                   Z-ADD     *ZERO         AECHGD
     C                   Z-ADD     *ZERO         AEPRDD
     C                   END
     C                   END
     C**
     C                   WRITE     AUDEFMT
     C                   ENDSR
     C*                                                              *
     C****************************************************************
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*    #BF   GENERATES FDAUDFPP.                                 *
     C*       CALLED BY  : #B                                        *
     C*       CALLS      :                                           *
     C*                                                              *
     C****************************************************************
     C**
     C     #BF           BEGSR
     C                   MOVEL     JOBAS         AFBAS
     C                   MOVEL     JOESD         AFESD
     C**
     C     JOENTT        IFEQ      'DL'
     C     JOENTT        OREQ      'DR'
     C     AFDLUX        IFLT      '0'
     C                   Z-ADD     *ZERO         AFDLUP
     C                   Z-ADD     *ZERO         AFYLUP
     C                   Z-ADD     *ZERO         AFTLUP
     C                   Z-ADD     *ZERO         AFLCD
     C                   END
     C                   END
     C**
     C                   WRITE     AUDFFMT
     C                   ENDSR
     C**
     C****************************************************************
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BG   GENERATES FDAUDGPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****      #BG       BEGSR                                          S01319
     C*****                MOVELJOBAS     AGBAS                           S01319
     C*****                MOVELJOESD     AGESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      AGDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     AGDLUP                          S01319
     C*****                Z-ADD*ZERO     AGYLUP                          S01319
     C*****                Z-ADD*ZERO     AGTLUP                          S01319
     C*****                Z-ADD*ZERO     AGLCD                           S01319
     C*****                Z-ADD*ZERO     AGBICN                          S01319
     C*****                Z-ADD*ZERO     AGNSCS                          S01319
     C*****                Z-ADD*ZERO     AGNECS                          S01319
     C*****                Z-ADD*ZERO     AGNBCB                          S01319
     C*****                Z-ADD*ZERO     AGNBCH                          S01319
     C*****                Z-ADD*ZERO     AGTNLU                          S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDGFMT                                   S01319
     C*****                ENDSR                                          S01319
     C*****                                                               S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BH   GENERATES FDAUDHPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****      #BH       BEGSR                                          S01319
     C*****                MOVELJOBAS     AHBAS                           S01319
     C*****                MOVELJOESD     AHESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      AHDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     AHDLUP                          S01319
     C*****                Z-ADD*ZERO     AHYLUP                          S01319
     C*****                Z-ADD*ZERO     AHTLUP                          S01319
     C*****                Z-ADD*ZERO     AHLCD                           S01319
     C*****                Z-ADD*ZERO     AHFLTP                          S01319
     C*****                Z-ADD*ZERO     AHFCOL                          S01319
     C*****                Z-ADD*ZERO     AHBCOL                          S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDHFMT                                   S01319
     C*****                ENDSR                                          S01319
     C*****                                                               S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BI   GENERATES FDAUDIPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****      #BI       BEGSR                                          S01319
     C*****                MOVELJOBAS     AIBAS                           S01319
     C*****                MOVELJOESD     AIESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      AIDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     AIDLUP                          S01319
     C*****                Z-ADD*ZERO     AIYLUP                          S01319
     C*****                Z-ADD*ZERO     AITLUP                          S01319
     C*****                Z-ADD*ZERO     AILCD                           S01319
     C*****                Z-ADD*ZERO     AITNLU                          S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDIFMT                                   S01319
     C*****                ENDSR                                          S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BJ   GENERATES FDAUDJPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****      #BJ       BEGSR                                          S01319
     C*****                MOVELJOBAS     AJBAS                           S01319
     C*****                MOVELJOESD     AJESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      AJDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     AJDLUP                          S01319
     C*****                Z-ADD*ZERO     AJYLUP                          S01319
     C*****                Z-ADD*ZERO     AJTLUP                          S01319
     C*****                Z-ADD*ZERO     AJLCD                           S01319
     C*****                Z-ADD*ZERO     AJSPOT                          S01319
     C*****                Z-ADD*ZERO     AJCDP                           S01319
     C*****                Z-ADD*ZERO     AJTNOT                          S01319
     C*****                Z-ADD*ZERO     AJTACC                          S01319
     C*****                Z-ADD*ZERO     AJTEQV                          S01319
     C*****                Z-ADD*ZERO     AJSWQV                          S01319
     C*****                Z-ADD*ZERO     AJTAC4                          S01319
     C*****                Z-ADD*ZERO     AJTAC5                          S01319
     C*****                Z-ADD*ZERO     AJPART                          S01319
     C*****                Z-ADD*ZERO     AJSSNO                          S01319
     C*****                Z-ADD*ZERO     AJERLC                          S01319
     C*****                Z-ADD*ZERO     AJMDIN                          S01319
     C*****                Z-ADD*ZERO     AJMDNA                          S01319
     C*****                Z-ADD*ZERO     AJMDNB                          S01319
     C*****                Z-ADD*ZERO     AJTNLU                          S01319
     C*****                Z-ADD*ZERO     AJSPDY                          S01319
     C*****                Z-ADD*ZERO     AJHISP                          S01319
     C*****                Z-ADD*ZERO     AJLOSP                          S01319
     C*****                Z-ADD*ZERO     AJCHGD                          S01319
     C*****                Z-ADD*ZERO     AJTSPC                          S01319
     C*****                Z-ADD*ZERO     AJSPDT                          S01319
     C*****                Z-ADD*ZERO     AJNQDP                          S01319
     C*****                Z-ADD*ZERO     AJDPBF                          S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDJFMT                                   S01319
     C*****                ENDSR                                          S01319
     C*****                                                               S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BK   GENERATES FDAUDKPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C*****      #BK       BEGSR                                          S01319
     C*****                MOVELJOBAS     AKBAS                           S01319
     C*****                MOVELJOESD     AKESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      AKHBEX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     AKHBER                          S01319
     C*****                Z-ADD*ZERO     AKLCD                           S01319
     C*****                Z-ADD*ZERO     AKTNLU                          S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDKFMT                                   S01319
     C*****                ENDSR                                          S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*    #BL   GENERATES FXAUDAPP.                                 *
     C*       CALLED BY  : #B                                        *
     C*       CALLS      :                                           *
     C*                                                              *
     C****************************************************************
     C**
     C**
     C     #BL           BEGSR
     C                   MOVEL     JOBAS         FLBAS
     C                   MOVEL     JOESD         FLESD
     C**
     C     JOENTT        IFEQ      'DL'
     C     JOENTT        OREQ      'DR'
     C     FLDLUX        IFLT      '0'
     C                   Z-ADD     *ZERO         FLDLUP
     C                   Z-ADD     *ZERO         FLYLUP
     C                   Z-ADD     *ZERO         FLTLUP
     C                   Z-ADD     *ZERO         FLLCD
     C                   Z-ADD     *ZERO         FLDLTC
     C                   Z-ADD     *ZERO         FLOLTC
     C                   END
     C                   END
     C**
     C                   WRITE     AUDLFMT
     C                   ENDSR
     C****************************************************************
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BM   GENERATES FXAUDBPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C*****      #BM       BEGSR                                          S01319
     C*****                MOVELJOBAS     FWBAS                           S01319
     C*****                MOVELJOESD     FWESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      FWDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     FWDLUP                          S01319
     C*****                Z-ADD*ZERO     FWYLUP                          S01319
     C*****                Z-ADD*ZERO     FWTLUP                          S01319
     C*****                Z-ADD*ZERO     FWLCD                           S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDMFMT                                   S01319
     C*****                ENDSR                                          S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*    #BN   GENERATES FXAUDCPP.                                 *
     C*       CALLED BY  : #B                                        *
     C*       CALLS      :                                           *
     C*                                                              *
     C****************************************************************
     C**
     C**
     C     #BN           BEGSR
     C                   MOVEL     JOBAS         FDBAS
     C                   MOVEL     JOESD         FDESD
     C**
     C     JOENTT        IFEQ      'DL'
     C     JOENTT        OREQ      'DR'
     C     FDDLUX        IFLT      '0'
     C                   Z-ADD     *ZERO         FDDLUP
     C                   Z-ADD     *ZERO         FDYLUP
     C                   Z-ADD     *ZERO         FDTLUP
     C                   Z-ADD     *ZERO         FDLCD
     C                   END
     C                   END
     C**
     C                   WRITE     AUDNFMT
     C                   ENDSR
     C****************************************************************
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BO   GENERATES FXAUDDPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C*****      #BO       BEGSR                                          S01319
     C*****                MOVELJOBAS     FJBAS                           S01319
     C*****                MOVELJOESD     FJESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      FJDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     FJDLUP                          S01319
     C*****                Z-ADD*ZERO     FJYLUP                          S01319
     C*****                Z-ADD*ZERO     FJTLUP                          S01319
     C*****                Z-ADD*ZERO     FJLCD                           S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDOFMT                                   S01319
     C*****                ENDSR                                          S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*    #BP   GENERATES FXAUDEPP.                                 *
     C*       CALLED BY  : #B                                        *
     C*       CALLS      :                                           *
     C*                                                              *
     C****************************************************************
     C**
     C**
     C     #BP           BEGSR
     C                   MOVEL     JOBAS         FSBAS
     C                   MOVEL     JOESD         FSESD
     C**
     C     JOENTT        IFEQ      'DL'
     C     JOENTT        OREQ      'DR'
     C     FSDLUX        IFLT      '0'
     C                   Z-ADD     *ZERO         FSDLUP
     C                   Z-ADD     *ZERO         FSYLUP
     C                   Z-ADD     *ZERO         FSTLUP
     C                   Z-ADD     *ZERO         FSLCD
     C                   END
     C                   END
     C**
     C                   WRITE     AUDPFMT
     C                   ENDSR
     C****************************************************************
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BQ   GENERATES FXAUDFPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C*****      #BQ       BEGSR                                          S01319
     C*****                MOVELJOBAS     FZBAS                           S01319
     C*****                MOVELJOESD     FZESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      FZDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     FZDLUP                          S01319
     C*****                Z-ADD*ZERO     FZYLUP                          S01319
     C*****                Z-ADD*ZERO     FZTLUP                          S01319
     C*****                Z-ADD*ZERO     FZLCD                           S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDQFMT                                   S01319
     C*****                ENDSR                                          S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BR   GENERATES FXAUDGPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****                                                               S01319
     C*****      #BR       BEGSR                                          S01319
     C*****                MOVELJOBAS     FYBAS                           S01319
     C*****                MOVELJOESD     FYESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      FYDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     FYDLUP                          S01319
     C*****                Z-ADD*ZERO     FYYLUP                          S01319
     C*****                Z-ADD*ZERO     FYTLUP                          S01319
     C*****                Z-ADD*ZERO     FYLCD                           S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDRFMT                                   S01319
     C*****                ENDSR                                          S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*    #BS   GENERATES MMAUDAPP.                                 *
     C*       CALLED BY  : #B                                        *
     C*       CALLS      :                                           *
     C*                                                              *
     C****************************************************************
      **
     C     #BS           BEGSR
     C                   MOVEL     JOBAS         HABAS
     C                   MOVEL     JOESD         HAESD
      **
     C     JOENTT        IFEQ      'DL'
     C     JOENTT        OREQ      'DR'
     C     HADLUX        IFLT      '0'
     C                   Z-ADD     *ZERO         HADLUP
     C                   Z-ADD     *ZERO         HAYLUP
     C                   Z-ADD     *ZERO         HATLUP
     C                   Z-ADD     *ZERO         HALCD
     C                   END
     C                   END
      **
     C                   WRITE     AUDSFMT
     C                   ENDSR
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BT   GENERATES MMAUDBPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****      #BT       BEGSR                                          S01319
     C*****                MOVELJOBAS     HBBAS                           S01319
     C*****                MOVELJOESD     HBESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      HBDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     HBDLUP                          S01319
     C*****                Z-ADD*ZERO     HBYLUP                          S01319
     C*****                Z-ADD*ZERO     HBTLUP                          S01319
     C*****                Z-ADD*ZERO     HBLCD                           S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDTFMT                                   S01319
     C*****                ENDSR                                          S01319
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*    #BU   GENERATES MMAUDCPP.                                 *
     C*       CALLED BY  : #B                                        *
     C*       CALLS      :                                           *
     C*                                                              *
     C****************************************************************
      **
     C     #BU           BEGSR
     C                   MOVEL     JOBAS         HCBAS
     C                   MOVEL     JOESD         HCESD
      **
     C     JOENTT        IFEQ      'DL'
     C     JOENTT        OREQ      'DR'
     C     HCDLUX        IFLT      '0'
     C                   Z-ADD     *ZERO         HCDLUP
     C                   Z-ADD     *ZERO         HCYLUP
     C                   Z-ADD     *ZERO         HCTLUP
     C                   Z-ADD     *ZERO         HCLCD
     C                   END
     C                   END
      **
     C                   WRITE     AUDUFMT
     C                   ENDSR
     C****************************************************************
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BV   GENERATES MMAUDDPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****      #BV       BEGSR                                          S01319
     C*****                MOVELJOBAS     HDBAS                           S01319
     C*****                MOVELJOESD     HDESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      HDDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     HDDLUP                          S01319
     C*****                Z-ADD*ZERO     HDYLUP                          S01319
     C*****                Z-ADD*ZERO     HDTLUP                          S01319
     C*****                Z-ADD*ZERO     HDLCD                           S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDVFMT                                   S01319
     C*****                ENDSR                                          S01319
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*    #BW   GENERATES MMAUDEPP.                                 *
     C*       CALLED BY  : #B                                        *
     C*       CALLS      :                                           *
     C*                                                              *
     C****************************************************************
      **
     C     #BW           BEGSR
     C                   MOVEL     JOBAS         HEBAS
     C                   MOVEL     JOESD         HEESD
      **
     C     JOENTT        IFEQ      'DL'
     C     JOENTT        OREQ      'DR'
     C     HEDLUX        IFLT      '0'
     C                   Z-ADD     *ZERO         HEDLUP
     C                   Z-ADD     *ZERO         HEYLUP
     C                   Z-ADD     *ZERO         HETLUP
     C                   Z-ADD     *ZERO         HELCD
     C                   END
     C                   END
      **
     C                   WRITE     AUDWFMT
     C                   ENDSR
     C****************************************************************
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BX   GENERATES MMAUDFPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****      #BX       BEGSR                                          S01319
     C*****                MOVELJOBAS     HFBAS                           S01319
     C*****                MOVELJOESD     HFESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      HFDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     HFDLUP                          S01319
     C*****                Z-ADD*ZERO     HFYLUP                          S01319
     C*****                Z-ADD*ZERO     HFTLUP                          S01319
     C*****                Z-ADD*ZERO     HFLCD                           S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDXFMT                                   S01319
     C*****                ENDSR                                          S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BY   GENERATES MMAUDGPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****      #BY       BEGSR                                          S01319
     C*****                MOVELJOBAS     HGBAS                           S01319
     C*****                MOVELJOESD     HGESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      HGDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     HGDLUP                          S01319
     C*****                Z-ADD*ZERO     HGYLUP                          S01319
     C*****                Z-ADD*ZERO     HGTLUP                          S01319
     C*****                Z-ADD*ZERO     HGLCD                           S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEAUDYFMT                                   S01319
     C*****                ENDSR                                          S01319
     C****************************************************************    S01319
     C/EJECT
     C****************************************************************
     C*                                                              *
     C*    #BZ   GENERATES FDAUDLPP.                                 *
     C*       CALLED BY  : #B                                        *
     C*       CALLS      :                                           *
     C*                                                              *
     C****************************************************************
      **
     C     #BZ           BEGSR
     C                   MOVEL     JOBAS         ALBAS
     C                   MOVEL     JOESD         ALESD
      **
     C     JOENTT        IFEQ      'DL'
     C     JOENTT        OREQ      'DR'
     C     ALDLUX        IFLT      '0'
     C                   Z-ADD     *ZERO         ALDLUP
     C                   Z-ADD     *ZERO         ALYLUP
     C                   Z-ADD     *ZERO         ALTLUP
     C                   Z-ADD     *ZERO         ALLCD
     C                   END
     C                   END
      **
     C                   WRITE     AUDZFMT
     C                   ENDSR
     C****************************************************************
     C/EJECT
     C****************************************************************    S01319
     C*****                                                          *    S01319
     C*****#BBA  GENERATES FDAUDMPP.                                 *    S01319
     C*****   CALLED BY  : #B                                        *    S01319
     C*****   CALLS      :                                           *    S01319
     C*****                                                          *    S01319
     C****************************************************************    S01319
     C*****                                                               S01319
     C*****      #BBA      BEGSR                                          S01319
     C*****                MOVELJOBAS     ANBAS                           S01319
     C*****                MOVELJOESD     ANESD                           S01319
     C*****                                                               S01319
     C*****      JOENTT    IFEQ 'DL'                                      S01319
     C*****      JOENTT    OREQ 'DR'                                      S01319
     C*****      ANDLUX    IFLT '0'                                       S01319
     C*****                Z-ADD*ZERO     ANDLUP                          S01319
     C*****                Z-ADD*ZERO     ANYLUP                          S01319
     C*****                Z-ADD*ZERO     ANTLUP                          S01319
     C*****                Z-ADD*ZERO     ANLCD                           S01319
     C*****                END                                            S01319
     C*****                END                                            S01319
     C*****                                                               S01319
     C*****                WRITEBUDAFMT                                   S01319
     C*****                ENDSR                                          S01319
     C****************************************************************    S01319
     C/EJECT                                                              S01145
     C**********************************************************   S01145 S01319
     C*****                                                        S01145 S01319
     C*****#BBB  GENERATES ABAUDCPP.                               S01145 S01319
     C*****   CALLED BY  : #B                                      S01145 S01319
     C*****   CALLS      :                                         S01145 S01319
     C*****                                                        S01145 S01319
     C**********************************************************   S01145 S01319
     C*****                                                        S01145 S01319
     C*****      #BBB      BEGSR                                   S01145 S01319
     C*****                MOVELJOBAS     JKBAS                    S01145 S01319
     C*****                MOVELJOESD     JKESD                    S01145 S01319
     C*****                                                        S01145 S01319
     C*****      JOENTT    IFEQ 'DL'                               S01145 S01319
     C*****      JOENTT    OREQ 'DR'                               S01145 S01319
     C*****      JKDLUX    IFLT '0'                                S01145 S01319
     C*****                Z-ADD*ZERO     JKDLUP                   S01145 S01319
     C*****                Z-ADD*ZERO     JKYLUP                   S01145 S01319
     C*****                Z-ADD*ZERO     JKTLUP                   S01145 S01319
     C*****                Z-ADD*ZERO     JKLCD                    S01145 S01319
     C*****                END                                     S01145 S01319
     C*****                END                                     S01145 S01319
     C*****                                                        S01145 S01319
     C*****                WRITEABACFMT                            S01145 S01319
     C*****                ENDSR                                   S01145 S01319
     C**********************************************************   S01145 S01319
     C/EJECT                                                              S01145
     C*************************************************************S01145 S01319
     C*****                                                        S01145 S01319
     C*****#BBC  GENERATES ABAUDDPP.                               S01145 S01319
     C*****   CALLED BY  : #B                                      S01145 S01319
     C*****   CALLS      :                                         S01145 S01319
     C*****                                                        S01145 S01319
     C*************************************************************S01145 S01319
     C*****                                                        S01145 S01319
     C*****      #BBC      BEGSR                                   S01145 S01319
     C*****                MOVELJOBAS     JLBAS                    S01145 S01319
     C*****                MOVELJOESD     JLESD                    S01145 S01319
     C*****                                                        S01145 S01319
     C*****      JOENTT    IFEQ 'DL'                               S01145 S01319
     C*****      JOENTT    OREQ 'DR'                               S01145 S01319
     C*****      JLDLUX    IFLT '0'                                S01145 S01319
     C*****                Z-ADD*ZERO     JLDLUP                   S01145 S01319
     C*****                Z-ADD*ZERO     JLYLUP                   S01145 S01319
     C*****                Z-ADD*ZERO     JLTLUP                   S01145 S01319
     C*****                Z-ADD*ZERO     JLLCD                    S01145 S01319
     C*****                END                                     S01145 S01319
     C*****                END                                     S01145 S01319
     C*****                                                        S01145 S01319
     C*****                WRITEABADFMT                            S01145 S01319
     C*****                ENDSR                                   S01145 S01319
     C*************************************************************S01145 S01319
     C/EJECT                                                              S01145
     C*************************************************************S01145 S01319
     C*****                                                        S01145 S01319
     C*****#BBD  GENERATES ABAUDEPP.                               S01145 S01319
     C*****   CALLED BY  : #B                                      S01145 S01319
     C*****   CALLS      :                                         S01145 S01319
     C*****                                                        S01145 S01319
     C*************************************************************S01145 S01319
     C*****                                                        S01145 S01319
     C*****      #BBD      BEGSR                                   S01145 S01319
     C*****                MOVELJOBAS     JNBAS                    S01145 S01319
     C*****                MOVELJOESD     JNESD                    S01145 S01319
     C*****                                                        S01145 S01319
     C*****      JOENTT    IFEQ 'DL'                               S01145 S01319
     C*****      JOENTT    OREQ 'DR'                               S01145 S01319
     C*****      JNDLUX    IFLT '0'                                S01145 S01319
     C*****                Z-ADD*ZERO     JNDLUP                   S01145 S01319
     C*****                Z-ADD*ZERO     JNYLUP                   S01145 S01319
     C*****                Z-ADD*ZERO     JNTLUP                   S01145 S01319
     C*****                Z-ADD*ZERO     JNLCD                    S01145 S01319
     C*****                END                                     S01145 S01319
     C*****                END                                     S01145 S01319
     C*****                                                        S01145 S01319
     C*****                WRITEABAEFMT                            S01145 S01319
     C*****                ENDSR                                   S01145 S01319
     C*************************************************************S01145 S01319
     C/EJECT                                                              S01319
     C****************************************************************    S01319
     C*                                                              *    S01319
     C*    #BBE  GENERATES FDAUDNPP.                                 *    S01328
     C*                                                              *    S01328
     C* THIS SR. IS A COPY OF #BZ, CONDITION AMDLUX < 0, IS NOT QUITE*    S01328
     C* UNDERSTOOD, BUT WE HAVE LEFT IT IN AS ALL OTHER SR. HAVE IT. *    S01328
     C*                                                              *    S01328
     C*       CALLED BY  : #B                                        *    S01328
     C*       CALLS      :                                           *    S01328
     C*                                                              *    S01328
     C****************************************************************    S01328
      **                                                                  S01328
     C     #BBE          BEGSR                                                                 S0132
     C                   MOVEL     JOBAS         AMBAS                                         S0132
     C                   MOVEL     JOESD         AMESD                                         S0132
      **                                                                  S01328
     C     JOENTT        IFEQ      'DL'                                                        S0132
     C     JOENTT        OREQ      'DR'                                                        S0132
     C     AMDLUX        IFLT      '0'                                                         S0132
     C                   Z-ADD     *ZERO         AMDLUP                                        S0132
     C                   Z-ADD     *ZERO         AMYLUP                                        S0132
     C                   Z-ADD     *ZERO         AMTLUP                                        S0132
     C                   Z-ADD     *ZERO         AMLCD                                         S0132
     C                   END                                                                   S0132
     C                   END                                                                   S0132
      **                                                                  S01328
     C                   WRITE     BUDBFMT                                                     S0132
     C                   ENDSR                                                                 S0132
     C****************************************************************    S01328
     C/EJECT                                                              S01328
     C****************************************************************    S01328
     C*                                                              *    S01328
     C*****#BBF**GENERATES FDAUDOPP.                                 *                S01328 BUG8891
     C*    #BBF  GENERATES FDAUDOPD.                                 *                       BUG8891
     C*                                                              *    S01328
     C* THIS SR. IS A COPY OF #BZ, CONDITION AODLUX < 0, IS NOT QUITE*    S01328
     C* UNDERSTOOD, BUT WE HAVE LEFT IT IN AS ALL OTHER SR. HAVE IT. *    S01328
     C*                                                              *    S01328
     C*       CALLED BY  : #B                                        *    S01328
     C*       CALLS      :                                           *    S01328
     C*                                                              *    S01328
     C****************************************************************    S01328
      **                                                                  S01328
     C     #BBF          BEGSR                                                                 S0132
     C                   MOVEL     JOBAS         AOBAS                                         S0132
     C                   MOVEL     JOESD         AOESD                                         S0132
      **                                                                  S01328
     C     JOENTT        IFEQ      'DL'                                                        S0132
     C     JOENTT        OREQ      'DR'                                                        S0132
     C     AODLUX        IFLT      '0'                                                         S0132
     C                   Z-ADD     *ZERO         AODLUP                                        S0132
     C                   Z-ADD     *ZERO         AOYLUP                                        S0132
     C                   Z-ADD     *ZERO         AOTLUP                                        S0132
     C                   Z-ADD     *ZERO         AOLCD                                         S0132
     C                   END                                                                   S0132
     C                   END                                                                   S0132
      **                                                                  S01328
     C                   WRITE     BUDCFMT                                                     S0132
     C                   ENDSR                                                                 S0132
     C****************************************************************    S01328
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
