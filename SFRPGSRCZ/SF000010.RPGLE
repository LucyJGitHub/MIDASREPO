     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SF Menu item maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Facility                            *
      *                                                               *
      *  SF000010 - Midas Menu Items Maintenance                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 246891             Date 25May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG5820            Date 17Mar05               *
      *                 CGP009             Date 22Dec04               *
      *                 BUG2287            Date 28Apr04               *
      *                 CSF002 *RENAME     Date 11Aug03               *
      *                 210779             Date 26Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201662             Date 06Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 153359             Date 05Jan99               *
      *****************************************************************
      *                                                               *
      *  246891 - Allow duplication of menu item short code and       *
      *           narrative.                                          *
      *  BUG5820- Change screen title to 'Client Menu Items Mainte-   *
      *           nance'/ 'Client Menu Items Enquiry"                 *
      *         - Add validation for atleast one action code must     *
      *           be entered.                                         *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  BUG2287- Show consolidated global view  (Recompile)          *
      *  CSF002 - Global Processing                                   *
      *           SF0010 has been converted to ILE and renamed.       *
      *           Commented out program codes have been stripped out  *
      *           for clarity.                                        *
      *  210779 - Display an error message that deletion or insertion *
      *           is prohibited if system is in Client mode.          *
      *  201662 - F3 is not working properly when done in SF0010      *
      *  153359 - New Program allowing users to select on the Menu    *
      *           Items file.                                         *
      *                                                               *
      ********************************************************************
     FSF000010DFCF   E             WORKSTN
     FSFMENUL3  UF A E           K DISK
     FSFMENUL1  IF   E           K DISK
     FGPMTXTL0  UF A E           K DISK
     FGPMTXTL1  IF   E           K DISK
     F                                     RENAME(GPMTXTD0:GPMTXTD1)
     FGPMTXTL2  IF   E           K DISK
     F                                     RENAME(GPMTXTD0:GPMTXTD2)
     FGPZONEL2  IF   E           K DISK
     FSDMMIDL1  IF   E           K DISK
     FSCSARIL3  UF   E           K DISK
     FMACBR2    UF   E           K DISK
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01  - GPMTXTL0 No Record Found Indicator                    *
      *   10  - GPMTXTL2 No Record Found Indicator                    *
      *   11  - Action code entered is a valid character              *
      *   12  - GPMTXTL1 No Record Found Indicator                    *
      *   13  - SDMMIDL1 No Record Found Indicator                    *
      *   14  - Duplicates not allowed                                *
      *   20  - First Cycle indicator                                 *
      *   21  - Detail processing                                     *
      *   22  - CSC011 is installed                                   *
      *   23  - Action code is  'A' -  AMEND                          *
      *   24  - Action code is  'D' -  DELETE                         *
      *   25  - Action code is  'E' -  ENQUIRE                        *
      *   26  - Action code is  'I' -  INSERT                         *
      *   27  - Work indicator for right adjusting                    *
      *   28  - GPMTXTL0 Readp End of File Indicator                  *
      *   29  - SFMENUL1 No Record Found Indicator                    *
      *   31  - Menu Item Short Code Error Indicator                  *
      *   32  - Module Shortname Error Indicator                      *
      *   33  - Item Narrative Error Indicator                        *
      *   34  - Security Level Error Indicator                        *
      *   35  - New Menu Item Short Code Error Indicator              *
      *   38  - Path/Command Parameters Error Indicator               *
      *   40  - GPZONEL2 No Record Found Indicator                    *
      *   41  - Execution Type Error Indicatior                       *
      *   42  - Frame Error Indicator                                 *
      *   45  - Action Allowed in COB Error Indicator                 *
      *   46  - API Name 1 Error Indicator                            *
      *   47  - API Name 2 Error Indicator                            *
      *   48  - API Name 3 Error Indicator                            *
      *   49  - API Name 4 Error Indicator                            *
      *   50  - API Name 5 Error Indicator                            *
      *   51  - SINS is not blank                                     *
      *   52  - SAMD is blank                                         *
      *   53  - SENQ is blank                                         *
      *   54  - SDEL is blank                                         *
      *   55  - SREV is blank                                         *
      *   56  - SCLO is blank                                         *
      *   58  - SREV is blank                                         *
      *   59  - SAUT is blank                                         *
      *   60  - SAUX1 is blank                                        *
      *   61  - SAUX2 is blank                                        *
      *   62  - SFLEND                                                *
      *   69  - Write fail to PF/SFMENUPD                             *
      *   76  - Error:-action code is not a valid character           *
      *   77  - Error:-duplication of action codes                    *
      *   80  - Errors Indicator                                      *
      *   81  - Work indicator for MACBR2                             *
      *   82  - "       "      "    "                                 *
      *   84  - Chain fail    LF/SCSARIL3                             *
      *   88  - Chain fail    LF/SFMENUL3                             *
      *   89  - QCMDCHK Ended in Error                                *
      *   90-99 Standard Sub-routines                                 *
      *   U7 U8                                                       *
      *                                                               *
      ********************************************************************
     F/EJECT
      ********************************************************************
     D ACTS            S              1    DIM(10)
     D AUX             S              1    DIM(10)
     D API             S              4    DIM(5)
     D INDI            S              1    DIM(5)
     D ALPH            S              1    DIM(27) CTDATA PERRCD(27)
     D WFRAM           S             20    DIM(2) CTDATA PERRCD(1)
     D ACTIND          S             11                                                      BUG5820
      *                                                                                      BUG5820
     D RUNDAT          DS
     D  AGMRDT                 1      7
     D  AGRDNB                 8     10P 0
     D  AGSUC                 11     11
     D  AGDFF                 12     12
     D  AGMBIN                13     13
     D*
     D                 DS
      *
      ** SCREEN DETAILS DATA STRUCTURE.
      *
     D  SACTN                  1      1
     D  SSNAM                  2     21
     D  SINAR                 22     66
     D  SSECL                 67     70
     D  SNAMM                 71     90
     D  SMODL                 91     92
     D  SMMSN                 93    102
     D  SEXTP                103    103
     D  SFRAM                104    123
     D  SPAT1                124    173
     D  SPAT2                174    223
     D  SINS                 224    224
     D  SAMD                 225    225
     D  SENQ                 226    226
     D  SDEL                 227    227
     D  SREV                 228    228
     D  SCLO                 229    229
     D  SPRI                 230    230
     D  SAUT                 231    231
     D  SAUX1                232    232
     D  SAUX2                233    233
     D  ACTION               224    233
     D  #2ACOB               234    234
     D  SAPI1                235    238
     D  SAPI2                239    242
     D  SAPI3                243    246
     D  SAPI4                247    250
     D  SAPI5                251    254
     D  WDSAPI               235    254
     D  SDATA2                 2    254
     D  SDATA3                22    254
     D  SCNDTA                 1    254
     D                 DS
      *
      **     SCREEN DETAILS DATA STRUCTURE.
      *
     D  INFELD                 1    254
     D  MISNAM                 2     21
     D  MIINAR                22     66
     D  MISECL                67     70  0
     D  MIMODC                91     92
     D  MIMMSN                93    102
     D  MIEXTP               103    103
     D  MIFRAM               104    123
     D  MIPATH               124    223
     D  MIAAC1               224    224
     D  MIAAC2               225    225
     D  MIAAC3               226    226
     D  MIAAC4               227    227
     D  MIAAC5               228    228
     D  MIAAC6               229    229
     D  MIAAC7               230    230
     D  MIAAC8               231    231
     D  MIAAC9               232    232
     D  MIAA10               233    233
     D  MIACOB               234    234
     D  MIAPI1               235    238
     D  MIAPI2               239    242
     D  MIAPI3               243    246
     D  MIAPI4               247    250
     D  MIAPI5               251    254
     D  OUTFLD                 1    254
     D                 DS
      *
      ** Unique Code
      *
     D  MIINDX                 1     10
     D  WLIBR                  1      2
     D  WNUM                   3     10  0
     D PSDS           SDS
     D**
     D**     PROGRAM STATUS DATA STRUCTURE
     D**
     D**       EXTYP & EXNUM ADDED TO MONITOR CPF MESSAGES ON CALL
     D**       TO QCMDCHK
     D  PGM              *PROC
     D  EXTYP                 40     42
     D  EXNUM                 43     46
     D  WSID                 244    246
     D  WSID2                245    246
     D  SWSID                244    253
     D  USRID                254    263
     D SDSTAT          DS           256
     D  LIBR                   6      7
     D**
     D**     STANDING DATA DATA STRUCTURE - SDSTAT
     D**
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D*
     D LDA            UDS           256
     D**
     D**     LOCAL DATA AREA
     D**
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     I********************************************************************
     I/EJECT
     I********************************************************************
     I@SARIL3
     I              ADMGRP                      SCMGRP
     ISFMENUD0
      ** Rename field
     I              MIAAC10                     MIAA10
      ** External DS for Switchable Features
      *
     I********************************************************************
     I/EJECT
     C     *ENTRY        PLIST
     C                   PARM                    P1RTNC            7
     C                   PARM                    P1SNAM           20
     C                   PARM                    P1INDX           10
     C                   PARM                    P1ACTN            1
     C                   PARM                    PKEY              2
      *
     C                   MOVEL     P1SNAM        SSNAM
     C                   MOVEL     P1ACTN        SACTN
     C********************************************************************
     C**                                                                **
     C**   THE PROGRAM WORKS OUT SIDE THE RPG CYCLE PROCESSING THE      **
     C**   SCREEN BY A LOOP. AN INITIAL CYCLE IS INCLUDED BUT ONLY      **
     C**   SO THAT PROCESSING WHICH IS DONE ONCE MAY BE SIMPLY          **
     C**   PERFORMED.                                                   **
     C**                *****************************                   **
     C**                                                                **
     C**   I N I T I A L   'C Y C L E'   P R O C E S S I N G            **
     C**                                                                **
     C********************************************************************
     C**
     C     *IN20         IFEQ      '0'
      *
      ** Determine if CSC011 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY '    POPTN             7
     C                   PARM      'CSC011'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC011            1
     C                   MOVE      '1'           *IN22
     C                   ELSE
     C                   MOVE      'N'           CSC011
     C                   MOVE      '0'           *IN22
     C                   ENDIF
     C**
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
     C**
     C                   MOVE      '1'           *IN20
     C**
     C**
     C**  GET RUN DATE FROM FROM RUNDAT
     C**
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
     C**
     C                   MOVE      AGRDNB        RUND              5 0
     C                   MOVE      AGMRDT        SRUNA
      *
      ** Message File
      *
     C                   MOVEL(P)  'SFUSRMSG'    PMSGF
      *
      ** Determine the zone name.
      *
     C     LIBR          CHAIN     GPZONEL2                           40
     C     *IN40         IFEQ      *OFF
     C                   MOVE      ZOZONE        SZONE
     C                   ENDIF
      *
     C                   END
     C**
     C********************************************************************
     C**                                                                **
     C**   I N I I T I A L   S C R E E N     P R O C E S S I N G        **
     C**                                                                **
     C********************************************************************
     C**
     C     SACTN         IFNE      'I'
     C                   GOTO      EXIST
     C                   ENDIF
      *
     C     *IN21         DOUEQ     '1'
     C**
     C     SACTN         IFNE      'I'
     C                   EXSR      ENDPGM
     C                   ENDIF
     C     *IN80         IFEQ      *ON
     C                   WRITE     SF000010C0
     C                   ENDIF
     C                   EXFMT     SF000010F0
     C     EXIST         TAG
      *
     C     SACTN         IFEQ      'I'
     C     *INKL         ANDEQ     '1'
     C                   EXSR      RTRNSC
     C                   ENDIF
      *
     C     SACTN         IFNE      'I'
     C     *INKL         ANDEQ     '1'
     C                   EXSR      ENDPGM
     C                   ENDIF
      *
     C     *INKC         CASEQ     '1'           ENDPGM
     C                   CAS                     INITSC
     C                   END
     C**
     C     SSECL         IFEQ      '    '
     C                   MOVE      '5000'        SSECL
     C                   END
     C                   MOVE      SSNAM         SNAMM
     C********************************************************************
     C**                                                                **
     C**   D E T A I L   S C R E E N     P R O C E S S I N G            **
     C**                                                                **
     C********************************************************************
     C**
     C     *IN21         DOWEQ     '1'
      *
     C     *IN80         IFEQ      *ON
     C                   WRITE     SF000010C0
     C                   ENDIF
      *
     C                   EXFMT     SF000010F1
     C     SACTN         IFEQ      'I'
     C     *INKL         ANDEQ     '1'
     C                   EXSR      RTRNSC
     C                   ENDIF
      *
     C     SACTN         IFNE      'I'
     C     *INKL         ANDEQ     '1'
     C                   EXSR      ENDPGM
     C                   ENDIF
      *
     C     *INKC         CASEQ     '1'           ENDPGM
     C     *INKJ         CASEQ     '1'           DELREC
     C                   CAS                     DSCRN
     C                   END
     C                   END
     C**
     C                   END
     C**
     C********************************************************************
     C**                                                                **
     C**     S U B R O U T I N E S  -   P R O G R A M                   **
     C**                                                                **
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**                                                                **
     C**  ENDPGM   SR. TO END PROGRAM                                   **
     C**           CALLED FROM DETAIL PROCESSING                        **
     C**                                                                **
     C********************************************************************
     C**
     C     ENDPGM        BEGSR
     C**
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '03'          PKEY
     C                   ENDIF
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C**
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**                                                                **
     C**  RTRNSC   SR. TO RETURN TO THE INITIAL SCREEN                  **
     C**           CALLED FROM DETAIL PROCESSING                        **
     C**                                                                **
     C********************************************************************
     C**
     C     RTRNSC        BEGSR
     C**
     C                   MOVE      *BLANKS       SCNDTA
     C                   MOVE      *OFF          *IN21
     C                   MOVE      *OFF          *IN22
     C                   MOVE      *OFF          *IN23
     C                   MOVE      *OFF          *IN24
     C                   MOVE      *OFF          *IN25
     C                   MOVE      *OFF          *IN26
     C                   MOVE      *OFF          *IN27
      *
      ** Initialise Error Indicators.
      *
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN33
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN38
     C                   MOVE      '0'           *INKL
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *OFF          *IN45
     C                   MOVE      *OFF          *IN46
     C                   MOVE      *OFF          *IN47
     C                   MOVE      *OFF          *IN48
     C                   MOVE      *OFF          *IN49
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN51
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN53
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN59
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN61
     C     *IN69         IFEQ      '0'
     C                   MOVE      *OFF          *IN80
     C                   EXSR      SRCLER
     C                   ELSE
     C                   MOVE      '1'           *IN80
     C                   MOVE      '0'           *IN69
     C                   END
     C**
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**                                                                **
     C**  DSCRN    SR. TO PROCESS THE DETAIL SCREEN                     **
     C**           CALLED FROM DETAIL PROCESSING                        **
     C**                                                                **
     C********************************************************************
     C**
     C     DSCRN         BEGSR
     C**
     C                   Z-ADD     0             Z
      *
      ** Initialise Error Indicators.
      *
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN33
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN38
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *OFF          *IN45
     C                   MOVE      *OFF          *IN46
     C                   MOVE      *OFF          *IN47
     C                   MOVE      *OFF          *IN48
     C                   MOVE      *OFF          *IN49
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN51
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN53
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN59
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN61
     C                   EXSR      SRCLER
     C**
     C**   AMEND SCREEN PROCESSING.
     C**
     C     *IN23         IFEQ      '1'
     C                   EXSR      DETLSC
     C     *IN80         IFEQ      '0'
     C     W0DEF         ANDNE     'Y'
     C                   EXSR      AMNDSR
     C                   END
     C                   END
     C**
     C**   INSERT SCREEN PROCESSING.
     C**
     C     *IN26         IFEQ      '1'
     C                   EXSR      DETLSC
     C     *IN80         IFEQ      '0'
     C     W0DEF         ANDNE     'Y'
     C                   EXSR      INSTSR
     C                   END
     C                   END
     C**
     C**   ENQUIRE SCREEN PROCESSING.
     C**
     C     *IN25         IFEQ      '1'
     C**
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN23
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN25
     C                   MOVE      '0'           *IN26
     C                   MOVE      *OFF          *IN80
     C                   MOVE      '0'           *INKL
      *
      ** Initialise Error Indicators.
      *
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN33
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN38
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *OFF          *IN45
     C                   MOVE      *OFF          *IN46
     C                   MOVE      *OFF          *IN47
     C                   MOVE      *OFF          *IN48
     C                   MOVE      *OFF          *IN49
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN51
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN53
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN59
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *BLANKS       SCNDTA
     C                   EXSR      SRCLER
     C**
     C                   END
     C**
     C                   ENDSR
     C**
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**                                                                **
     C**  INITSC   SR. TO PROCESS THE INITIAL SCREEN                    **
     C**           CALLED FROM DETAIL PROCESSING                        **
     C**                                                                **
     C********************************************************************
     C     INITSC        BEGSR
      *
     C                   Z-ADD     0             Z                 2 0
      *
     C                   MOVE      '0'           *IN21
     C                   MOVE      *OFF          *IN80
     C                   MOVE      '0'           *IN23
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN25
     C                   MOVE      '0'           *IN26
      *
      ** Initialise Error Indicators.
      *
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN33
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN38
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *BLANKS       INFELD
     C                   MOVE      *BLANKS       SDATA3
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *OFF          *IN45
     C                   MOVE      *OFF          *IN46
     C                   MOVE      *OFF          *IN47
     C                   MOVE      *OFF          *IN48
     C                   MOVE      *OFF          *IN49
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN51
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN53
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN59
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN61
     C                   EXSR      SRCLER
      *
      ** A VALID ACTION CODE.
      *
     C     SACTN         IFEQ      'A'
     C                   MOVE      '1'           *IN23
     C                   END
      *
     C     SACTN         IFEQ      'D'
     C                   MOVE      '1'           *IN24
     C                   END
      *
     C     SACTN         IFEQ      'E'
     C                   MOVE      '1'           *IN25
     C                   END
      *
     C     SACTN         IFEQ      'I'
     C                   MOVE      '1'           *IN26
     C                   END
      *
      ** Menu Item Short Code is mandatory.
      *
     C     SSNAM         IFEQ      *BLANKS
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0408'     PMSID
     C                   EXSR      SRSNMS
     C                   ELSE
      **********                                                                              246891
      ***Menu*Item Short Code must be unique globally.                                        246891
      **********                                                                              246891
     C*****SSNAM         CHAIN     GPMTXTL1                           12                      246891
     C******IN12         IFEQ      *OFF                                                       246891
     C*****P1INDX        ANDNE     MIINDX                                                     246891
     C**********         MOVE      *ON           *IN31                                        246891
     C**********         MOVE      *ON           *IN80                                        246891
     C**********         ADD       1             Z                                            246891
     C**********         MOVEL     'SFM0409'     PMSID                                        246891
     C**********         EXSR      SRSNMS                                                     246891
     C**********         ELSE                                                                 246891
     C                   MOVEL     SSNAM         SSNAM
     C**********         ENDIF                                                                246891
     C                   ENDIF
      *
      **   Proceed only if there are no errors.
      *
     C     Z             IFEQ      0
      *
      **   Check if there is an existing record.
      *
     C     SACTN         IFNE      'I'
     C     P1INDX        CHAIN     SFMENUL3                           88
     C     P1INDX        CHAIN     GPMTXTL0                           01
      *
      **If found, save the record.
      *
     C     *IN88         IFEQ      '0'
     C                   MOVE      INFELD        SDATA2
     C                   MOVE      INFELD        WSAVE           254
      *
     C                   EXCEPT    MITMRL
     C                   ENDIF
      *
     C                   ENDIF
      *
      **   For Delete, Amend or Enquiry a live record must exist.
      *
     C     SACTN         IFEQ      'A'
     C     SACTN         OREQ      'D'
     C     SACTN         OREQ      'E'
     C     *IN88         IFEQ      '1'
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0410'     PMSID
     C                   EXSR      SRSNMS
     C                   END
     C                   END
      *
     C                   END
      *
      **   Check whether a valid Screen
      *
     C     *IN80         IFEQ      *OFF
     C                   MOVE      *ON           *IN21
     C                   END
      *
     C                   ENDSR
      *
     C********************************************************************
     C/EJECT
      ********************************************************************
      *                                                                  *
      *   DETLSC   SR. TO PROCESS THE DETAIL SCREEN                      *
      *            CALLED FROM DETAIL PROCESSING                         *
      *                                                                  *
      ********************************************************************
      *
     C     DETLSC        BEGSR
      *
     C                   Z-ADD     0             Z                 2 0
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN33
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN38
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *OFF          *IN45
     C                   MOVE      *OFF          *IN46
     C                   MOVE      *OFF          *IN47
     C                   MOVE      *OFF          *IN48
     C                   MOVE      *OFF          *IN49
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN51
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN53
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN59
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN61
     C                   EXSR      SRCLER
      *
      **   Item Narrative is mandatory.
      *
     C     SINAR         IFEQ      *BLANKS
      *
     C                   MOVE      *ON           *IN33
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0411'     PMSID
     C                   EXSR      SRSNMS
     C**********         ELSE                                                                 246891
      **********                                                                              246891
      *****Item*Narrative must be unique globally.                                            246891
      **********                                                                              246891
     C*****SINAR         CHAIN     GPMTXTL2                           10                      246891
     C******IN10         IFEQ      *OFF                                                       246891
     C*****P1INDX        ANDNE     MIINDX                                                     246891
     C**********         MOVE      *ON           *IN33                                        246891
     C**********         MOVE      *ON           *IN80                                        246891
     C**********         ADD       1             Z                                            246891
     C**********         MOVEL     'SFM0412'     PMSID                                        246891
     C**********         EXSR      SRSNMS                                                     246891
     C**********         END                                                                  246891
     C                   END
      *
      **   Security Level
      *
      **   Right adjust security level field
      *
     C                   MOVE      '0'           *IN27
     C     *IN27         DOWEQ     '0'
      *
     C                   MOVE      SSECL         CHEK01            1
     C     CHEK01        IFEQ      ' '
     C                   MOVEL     SSECL         CHEK03            3
     C                   MOVE      CHEK03        SSECL
     C                   MOVEL     '0'           SSECL
     C                   MOVE      '0'           *IN27
     C                   ELSE
     C                   MOVE      '1'           *IN27
     C                   END
     C                   END
      *
      **  Security Level must be numeric.
      *
     C                   MOVEL     SSECL         CHKN05            5 0
     C                   MOVEL     CHKN05        CHEK04            4
     C     SSECL         IFNE      CHEK04
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0413'     PMSID
     C                   EXSR      SRSNMS
     C                   END
      *
     C     *IN23         IFEQ      *ON
     C     SNAMM         IFEQ      SSNAM
     C                   ELSE
     C     SNAMM         IFEQ      ' '
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0414'     PMSID
     C                   EXSR      SRSNMS
     C                   ELSE
     C     SNAMM         CHAIN     GPMTXTL1                           12
     C     *IN12         IFEQ      *OFF
     C     P1INDX        ANDNE     MIINDX
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0415'     PMSID
     C                   EXSR      SRSNMS
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ** Midas Module Shortname is mandatory.
      *
     C     SMMSN         IFEQ      *BLANK
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0428'     PMSID
     C                   EXSR      SRSNMS
     C                   ELSE
      *
      ** Midas Module Shortname must be existing in Midas SD Midas modules
      *
     C     SMMSN         CHAIN     SDMMIDL1                           13
      *
     C     *IN13         IFEQ      *ON
     C     FOMMIN        ORNE      'Y'
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0416'     PMSID
     C                   EXSR      SRSNMS
     C                   ELSE
     C                   MOVE      FOUNIQ        SMODL
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Execution Type
      *
     C                   MOVEL     'N'           W0DEF             1
     C     SEXTP         IFEQ      *BLANK
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0429'     PMSID
     C                   EXSR      SRSNMS
     C                   ELSE
     C                   MOVEL     *BLANK        P0RTN             7
     C                   MOVEL     SEXTP         P0NSRQ            1
      *
      ** Name search required?
      *
     C     P0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM                    P0RTN
     C                   PARM      1110282       Y2LSNO            7 0
     C     SEXTP         PARM      SEXTP         P0EXVL           20
      *
      ** Defer Update of file
      *
     C                   MOVEL     'Y'           W0DEF
      *
     C                   ELSE
     C     SEXTP         IFNE      'W'
     C     SEXTP         ANDNE     'J'
     C     SEXTP         ANDNE     'A'
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0417'     PMSID
     C                   EXSR      SRSNMS
     C                   END
     C                   END
     C                   ENDIF
      *
      ** Validate Frame
      *
     C     SFRAM         IFEQ      *BLANK
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0430'     PMSID
     C                   EXSR      SRSNMS
     C                   ELSE
     C                   MOVEL     *BLANK        P0RTN
     C                   MOVEL     SFRAM         P0NSRQ            1
      *
      ** Name search required?
      *
     C     P0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM                    P0RTN
     C                   PARM      1110283       Y2LSNO            7 0
     C     SFRAM         PARM      SFRAM         P0EXVL           20
      *
      ** Defer Update of file
      *
     C                   MOVEL     'Y'           W0DEF
      *
     C                   ELSE
     C     SFRAM         IFNE      WFRAM(1)
     C     SFRAM         ANDNE     WFRAM(2)
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0418'     PMSID
     C                   EXSR      SRSNMS
     C                   END
      *
     C                   END
     C                   ENDIF
      *
      ** Path/Command Parameters is mandatory.
      *
     C     SPAT1         IFEQ      *BLANKS
     C     SPAT2         ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0419'     PMSID
     C                   EXSR      SRSNMS
     C                   END
      *
      **   Check Path/Command Parameters is valid. If Execution type is 'W' or 'A', then
      **   this must be a valid command string.
      *
     C     SEXTP         IFEQ      'W'
     C     SEXTP         OREQ      'A'
     C     SPAT1         CAT       SPAT2:0       CHK              90
     C                   Z-ADD     90            CHKLEN           15 5
     C                   CALL      'QCMDCHK'                            89
     C                   PARM                    CHK
     C                   PARM                    CHKLEN
      *
      **     If QCMDCHK returns a CPF0006, then the Path/Command Parameters
      **     are invalid,
      *
     C     *IN89         IFEQ      '1'
     C     EXTYP         IFEQ      'CPF'
     C     EXNUM         ANDEQ     '0006'
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0420'     PMSID
     C                   EXSR      SRSNMS
     C                   END
     C                   END
     C                   ENDIF
      *
      ** Validation of API Names
      *
      ** Must be unique.
      *
     C                   MOVEA     WDSAPI        API
     C                   Z-ADD     1             W                 1 0
     C                   MOVEA     '00000'       INDI
      *
     C     W             DOWLT     6
     C                   MOVE      API(W)        W#API             4
     C     W#API         CHAIN     SFMENUL1                           29
     C     *IN29         IFEQ      *OFF
     C     P1INDX        ANDNE     MIINDX
     C                   MOVE      '1'           INDI(W)
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0421'     PMSID
     C                   EXSR      SRSNMS
     C                   ENDIF
     C                   ADD       1             W
     C                   ENDDO
      *
      ** Duplicates not allowed.
      *
     C                   MOVEA     WDSAPI        API
     C                   Z-ADD     1             W                 1 0
      *
     C     W             DOWLT     6
     C                   MOVE      API(W)        W#API             4
     C                   MOVE      *BLANK        API(W)
     C     W#API         LOOKUP    API(1)                                 14
     C     *IN14         IFEQ      *ON
     C     W#API         ANDNE     *BLANKS
     C                   MOVE      '11111'       INDI
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0422'     PMSID
     C                   EXSR      SRSNMS
     C                   ENDIF
     C                   ADD       1             W
     C                   ENDDO
      *
     C                   MOVEA     INDI          *IN(46)
      *
     C**             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C**             ACTION CODES ALLOWED :: VALIDATION
     C**             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C**********         SETOFF                                       7677                   BUG5820
     C                   SETOFF                                       767778                 BUG5820
     C                   MOVE      *ZEROS        ACTIND                                      BUG5820
     C                   MOVEA     ACTIND        *IN(51)                                     BUG5820
      *                                                                                      BUG5820
     C                   IF        ACTION = *BLANKS                                          BUG5820
     C                   MOVE      '11111111111' ACTIND                                      BUG5820
     C                   MOVEA     ACTIND        *IN(51)                                     BUG5820
     C                   MOVE      *ON           *IN76                                       BUG5820
     C                   MOVE      *ON           *IN78                                       BUG5820
     C                   ELSE                                                                BUG5820
                                                                                             BUG5820
     C     SINS          COMP      ' '                                5151
     C     SAMD          COMP      ' '                                5252
     C     SENQ          COMP      ' '                                5353
     C     SDEL          COMP      ' '                                5454
     C     SREV          COMP      ' '                                5555
     C     SCLO          COMP      ' '                                5656
     C     SPRI          COMP      ' '                                5858
     C     SAUT          COMP      ' '                                5959
     C     SAUX1         COMP      ' '                                6060
     C     SAUX2         COMP      ' '                                6161
     C**
     C**
     C** TEST ACTION CODES ARE CHARACTERS A-Z OR BLANK
     C**
     C     SINS          LOOKUP    ALPH                                   11
     C   11SAMD          LOOKUP    ALPH                                   11
     C   11SENQ          LOOKUP    ALPH                                   11
     C   11SDEL          LOOKUP    ALPH                                   11
     C   11SREV          LOOKUP    ALPH                                   11
     C   11SCLO          LOOKUP    ALPH                                   11
     C   11SPRI          LOOKUP    ALPH                                   11
     C   11SAUT          LOOKUP    ALPH                                   11
     C   11SAUX1         LOOKUP    ALPH                                   11
     C   11SAUX2         LOOKUP    ALPH                                   11
     C     *IN11         IFEQ      '0'
      *
      **  ONE OR MORE ACTION CODE IS INVALID, IND. 76
      *
     C                   SETON                                        76
     C                   END
     C                   ENDIF                                                               BUG5820
      *
      **  IF ALL ACTION CODES ARE VALID THEN CHECK THERE IS NO
      **  DUPLICATION OF ACTIONS ENTERED IND. 77 = DUPLICATION.
      *
     C     *IN76         IFEQ      '0'
     C                   MOVEA     ACTION        ACTS
     C   51SINS          LOOKUP    ACTS(2)                                77
     C   52
     CANN77SAMD          LOOKUP    ACTS(3)                                77
     C   53
     CANN77SENQ          LOOKUP    ACTS(4)                                77
     C   54
     CANN77SDEL          LOOKUP    ACTS(5)                                77
     C   55
     CANN77SREV          LOOKUP    ACTS(6)                                77
     C   56
     CANN77SCLO          LOOKUP    ACTS(7)                                77
     C   58
     CANN77SPRI          LOOKUP    ACTS(8)                                77
     C   59
     CANN77SAUT          LOOKUP    ACTS(9)                                77
     C   60
     CANN77SAUX1         LOOKUP    ACTS(10)                               77
     C                   END
     C*
     C     *IN76         IFEQ      '1'
     C     *IN77         OREQ      '1'
     C     *IN78         OREQ      *ON                                                       BUG5820
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C     *IN76         IFEQ      *ON
     C                   MOVEL     'SFM0423'     PMSID
     C                   ENDIF
     C     *IN77         IFEQ      *ON
     C                   MOVEL     'SFM0424'     PMSID
     C                   ENDIF
     C     *IN78         IFEQ      *ON                                                       BUG5820
     C                   MOVEL     'SFM0431'     PMSID                                       BUG5820
     C                   ENDIF                                                               BUG5820
     C                   EXSR      SRSNMS
      *
     C                   ELSE
      *
      **   Check for any blanks within the action codes that are not at
      **   the end of the list
      *
     C                   MOVEA     *BLANKS       AUX
     C                   Z-ADD     1             X                 3 0
     C                   Z-ADD     1             Y                 3 0
     C                   DO        10
     C     ACTS(X)       IFNE      ' '
     C                   MOVE      ACTS(X)       AUX(Y)
     C                   ADD       1             Y
     C                   ADD       1             X
     C                   ELSE
     C                   ADD       1             X
     C                   END
     C                   END
      *
     C                   MOVEA     AUX           ACTION
      *
     C                   END
      *
      ** Validate actions permitted during COB field
      *
     C     #2ACOB        IFNE      *BLANKS
     C     #2ACOB        ANDNE     'A'
     C     #2ACOB        ANDNE     'N'
     C     #2ACOB        ANDNE     'E'
     C                   MOVE      *ON           *IN45
     C                   MOVE      *ON           *IN80
     C                   ADD       1             Z
     C                   MOVEL     'SFM0425'     PMSID
     C                   EXSR      SRSNMS
     C                   ELSE
     C                   MOVE      '0'           *IN45
     C                   ENDIF
      *
      **             End of validation processing.
      *              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C**
     C**   Change of menu group or item processing.
     C**
     C     *IN80         IFEQ      '0'
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN33
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN38
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *OFF          *IN45
     C                   MOVE      *OFF          *IN46
     C                   MOVE      *OFF          *IN47
     C                   MOVE      *OFF          *IN48
     C                   MOVE      *OFF          *IN49
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN51
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN53
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN59
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN61
     C                   EXSR      SRCLER
     C                   END
     C**
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**                                                                **
     C**  DELREC   SR. TO FLAG A RECORD FOR DELETION                    **
     C**           CALLED FROM DETAIL PROCESSING                        **
     C**                                                                **
     C********************************************************************
     C     DELREC        BEGSR
     C**
     C     *IN24         IFEQ      '0'
     C                   MOVEL     'SFM0426'     PMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN80
     C                   ELSE
     C     P1INDX        CHAIN     SFMENUL3                           88
     C     P1INDX        CHAIN     GPMTXTL0                           01
     C     *IN88         IFEQ      *ON
     C     INFELD        ORNE      WSAVE
     C                   MOVE      *ON           *IN88
     C                   MOVEL     'SFM0427'     PMSID
     C                   EXSR      SRSNMS
     C                   END
      *
     C     *IN88         IFEQ      *OFF
      *
      **    UPDATE RECORDS ON SWITCHABLE MENU ITEMS FILE (SCSARIL3)
      *
     C                   EXSR      UPDTSR
      *
      **    UPDATE RECORD ON MENU ITEMS FILE (MITEM)
      *
     C     P1INDX        CHAIN     SFMENUL3                           69
     C     P1INDX        CHAIN     GPMTXTL0                           01
     C     *IN69         IFEQ      *ON
     C                   MOVEL     'SFM0427'     PMSID
     C                   EXSR      SRSNMS
     C                   ELSE
     C                   MOVE      SDATA2        OUTFLD
     C                   MOVEL     SNAMM         MISNAM
     C                   MOVE      'Y'           MIDEL
     C                   DELETE    SFMENUD0
     C                   UPDATE    GPMTXTD0
     C                   ENDIF
     C                   END
      *
      **    Delete Record from MACBR2
      *
     C     P1INDX        SETLL     MACBR2                                 81
     C     *IN81         IFEQ      '1'
      *
     C     LOOP          TAG
     C     P1INDX        READE     MACBR2                                 82
     C*
     C     *IN82         IFEQ      '0'
     C                   DELETE    MACBRDDF
     C                   GOTO      LOOP
     C                   END
     C                   END
      *
     C                   EXSR      RTRNSC
     C                   END
      *
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**                                                                **
     C**  INSTSR   SR. TO INSERT A RECORD ON SFMENUPD AND GPMTXTPD      **
     C**           CALLED FROM SR. DETLSC                               **
     C**                                                                **
     C********************************************************************
     C     INSTSR        BEGSR
      *
      **   Check the next available unique code.
      *
     C     LIBR          CAT       '99999999'    KIINDX           10
     C     KIINDX        SETLL     GPMTXTL0
     C                   READP     GPMTXTL0                               28
     C     *IN28         IFEQ      *OFF
     C     WLIBR         ANDEQ     LIBR
     C     WNUM          ANDNE     99999999
     C     WNUM          ADD       1             WINNUM            8 0
     C                   MOVE      WINNUM        WINALP            8
     C     LIBR          CAT       WINALP        WINDX            10
     C                   ELSE
     C     LIBR          CAT       '00000001'    WINDX
     C                   ENDIF
      *
     C                   MOVE      WINDX         MIINDX
     C                   MOVE      ' '           MIDEL
     C                   MOVEL     USRID         MIINS
      *
     C                   MOVE      SDATA2        OUTFLD
     C                   WRITE     SFMENUD0                             69
     C                   WRITE     GPMTXTD0                             69
     C**
     C     *IN69         IFEQ      *ON
     C                   MOVEL     'SFM0427'     PMSID
     C                   EXSR      SRSNMS
     C                   END
      *
     C**
     C                   EXSR      RTRNSC
     C**
     C                   ENDSR
     C**
     C********************************************************************
     C/EJECT
      ********************************************************************
      *                                                                 **
      *   AMNDSR   SR. TO AMEND A RECORD ON SFMENUPD AND GPMTXTPD       **
      *            CALLED FROM SR. DETLSC                               **
      *                                                                 **
      ********************************************************************
      *
     C     AMNDSR        BEGSR
      *
      ** Amend menu item
      *
      **    Attempt to access record on file.
      **     If successful check whether last change time has altered.
      **     If it has send UPDATE message, and release record.
      *
     C     P1INDX        CHAIN     SFMENUL3                           88
     C     P1INDX        CHAIN     GPMTXTL0                           01
     C     *IN88         IFEQ      '0'
     C     INFELD        IFNE      WSAVE
     C                   MOVE      *ON           *IN69
     C                   MOVEL     'SFM0427'     PMSID
     C                   EXSR      SRSNMS
     C                   EXCEPT    MITMRL
      *
     C                   ELSE
      *
      **    If Item Narrative has been amended, Update records on Swithcable
      **    Menu Items File.
      **    (SCSARIL3)
      *
     C     SINAR         IFNE      MIINAR
     C                   EXSR      UPDTSR
     C                   END
     C                   MOVE      SDATA2        OUTFLD
     C     P1INDX        CHAIN     SFMENUL3                           69
     C     P1INDX        CHAIN     GPMTXTL0                           01
     C     *IN69         IFEQ      *ON
     C                   MOVEL     'SFM0427'     PMSID
     C                   EXSR      SRSNMS
     C                   ELSE
     C                   MOVE      SDATA2        OUTFLD
     C                   MOVEL     SNAMM         MISNAM
     C                   UPDATE    SFMENUD0
     C                   UPDATE    GPMTXTD0
     C                   ENDIF
     C                   END
      *
     C                   ELSE
      *
      **     Failure to access a record requires an UPDATE message
      **     to be sent.
      *
     C                   MOVE      *ON           *IN69
     C                   MOVEL     'SFM0427'     PMSID
     C                   EXSR      SRSNMS
      *
     C                   END
      *
     C                   EXSR      RTRNSC                                                    **
      *
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**                                                                **
     C**  UPDTSR   SR. TO UPDATE RECORD ON PF/SCSARIPD                  **
     C**           CALLED FROM SR. DELREC, SR. INSTSR, SR. AMNDSR       **
     C**                                                                **
     C********************************************************************
     C**
     C     UPDTSR        BEGSR                                                   ** UPDTSR SR *
     C**
     C**     PROCESS ALL RECORDS ON SCSARIL3 FOR THE MENU GROUP AND
     C**     ITEM CODE
     C**
     C     P1INDX        CHAIN     SCSARIL3                           84
     C     *IN84         DOWEQ     '0'
     C**
     C**     IF MENU ITEM IS SAR-RELATED
     C**
     C**
     C**     IF ACTION IS DELETE
     C**
     C     SACTN         IFEQ      'D'
     C                   DELETE    @SARIL3
     C                   END
      *
      **     IF ACTION IS AMEND
      *
     C     SACTN         IFEQ      'A'
     C                   MOVE      'D'           ADRECI
     C                   MOVEL     SINAR         ADINAR
     C                   MOVE      SACTN         ADTYLC
     C                   Z-ADD     RUND          ADLCD
     C                   UPDATE    @SARIL3
     C                   END
      *
     C     P1INDX        READE     SCSARIL3                               84
     C                   END
     C**
     C                   ENDSR
     C**
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSNMS - Send message to program's message queue             *
      *                                                               *
      *****************************************************************
      *
     C     SRSNMS        BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      PGM           PPGMQ            10
     C                   PARM      '*SAME'       PPGRL             5
     C                   PARM                    PMSID             7
     C                   PARM                    PMSGF            10
     C                   PARM                    PMSDA           132
     C                   PARM                    PMSTP             7
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLER - Clear messages in program queue                     *
      *                                                               *
      *  Called By : Main Processing, SRVALD, SRUPSC, SRUPPR, SRPR12  *
      *              SRCF51, SRVUPS, SRIZSF, SRLOAD, SRDSPS, SRCF52   *
      *              SRVALS, SRSFPR                                   *
      *                                                               *
      *  Calls     : Y2CLMSC,                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRCLER        BEGSR
      *
      ** Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      PGM           PPGMQ            10
     C                   PARM      '*SAME'       PPGRL             5
     C                   WRITE     SF000010C0
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     O**
     O**   RELEASE SFMENUPD RECORD ACCESSED DURING PROCESSING.
     O**
     OSFMENUD0  E            MITMRL
     O**
     O*********************************************************************
** ALPH - VALID LETTERS
ABCDEFGHIJKLMNOPQRSTUVWXYZ
** WFRAM - Valid Frame Values
menucontent
mainmenu
