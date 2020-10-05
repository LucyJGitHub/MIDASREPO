     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DH***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas BU SD main client detls background update')      *
     F********************************************************************
     F*                                                                  *
     F*  Midas STANDING DATA MODULE
     F*                                                                  *
     F*  SDCLINT - BACKGROUND UPDATE OF CLINTCB FILE                     *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 AR830675           Date 16Sep11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23967B          Date 02Jun09               *
      *                 BUG23967           Date 13May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 146789             Date 28Apr99               *
     F*                 086902             Date 02MAY95               *
     F*                 086126             DATE 30MAR95               *
     F*                 S01429             DATE  9JUL93                  *
     F*                 S01413             DATE 18JUN93                  *
     F*                 E38729             DATE 03JUL92                  *
     F*                 E30555             DATE 11MAR92                  *
     F*                 RT0056             DATE 07MAY91                  *S01267
     F*                    S01267             DATE 14SEP90               *S01267
     F*                    E18406             DATE 22NOV89               *E18406
     F*                    S01117             DATE 07MAR90               *S01117
     F*                    S01230             DATE 07/11/89              *S01229
     F*                    S01229             DATE 20/10/89              *S01229
     F*                    E17239             DATE 10/05/87              *S01229
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
     F*     ERROR NO.     DESCRIPTION OF ERROR                           *
     F*                                                                  *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR830675 - GF - Maintain Customers - Add. Cust. Inf. 2 -        *
      *             entered lang. ID not defaulted                       *
      *             (Child: AR830676)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
     F*  BUG23967B - Local industry code field uses old LIND             *
     F*              it should be LOIC                                   *
     F*  BUG23967  - Add Local Industry Code Field. (Recompile)          *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
     F*     146789        -Write the correspondent record with language  *
     F*                   code Blank instead of 'GB'.                    *
     F*     086902        Correct look up of switchable feature          *
     F*     086126        Write to UDC files if needed                   *
     F*     S01429        CHIPS 2 incorporation.                         *
     F*                   - New CHIPS 2 ABA field added.                 *
     F*     S01413        Retail 3 incorporation. Retail Customer group  *
     F*                   added to CLINTCB.                              *
     F*     E38729        Customer type not being updated properly on    *
     F*                   CLINT file during customer details amendment.  *
     F*                   /MOVE field WCSTY (Customer Type) instead of   *
     F*                   WTYLC (Type of Last Change) unto field CTYP.   *
     F*     E30555        IF CHIPS ID IS ZERO OR BLANK IN SDCUSTPD       *
     F*                   THEN MOVE BLANKS TO 9A CHID IN CLINTCB         *
     F*                   SO MESSAGE WILL BE GENERATED CORRECTLY         *
     F*     RT0056        PARAMETERS BEING RECEIVED IN WRONG ORDER       *
     F*     S01267        MIS RELEASE 2.2 CHANGES.                       *
     F*     E18406        DATE A CUSTOMER DELETED WAS NOT MOVED TO       *E18406
     F*                   THE FIELD 'DATE OF DELETION' IN CLINT          *E18406
     F*     S01117        REL 10 MULTI-BRANCHING                         *
     F*     S01230        STANDARDISE PROGRAMS                           *
     F*     E17239        GSFM INDICATOR NOT BLANKED OUT IF STTX ADDRESS *
     F*                   TELEX ADDRESS AND SWIFT ID ARE ALL BLANK       *
     F*     S01229        SYNON FIELD NAME CHANGES                       *S01229
     F********************************************************************
     F*                                                                  *
     F* ID F  C  H  L    FUNCTION OF INDICATORS                          *
     F*                                                                  *
     F*       30         CHAIN to client file detail fails.              *
     F*       31         WRITE to client file detail fails.              *
     F*       32         UPDATE of client detail fails.                  *
     F*       33         CHAIN to client file control fails.             *
     F*       34         UPDATE of client file control fails.            *
     F*                                                                  *
     F********************************************************************
     FCLINT     UF A E           K DISK
     F                                     COMMIT
     F                                     IGNORE(CLINTCCF)
     F                                     IGNORE(CLINTC1F)
     F                                     IGNORE(CLINTSEF)
      *                                                                                       086126
     FCGCORRL0  UF A E           K DISK    USROPN                                             086126
     F                                     COMMIT                                             086126
      * UPD : Correspondent Details     Update index                                          086126
     F/COPY WNCPYSRC,SDCLINTF01
      *                                                                                       086126
      /EJECT
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D********************************************************************
      /EJECT
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
      *                                                                                       086126
     D @1DBRC        E DS                  EXTNAME(CGCORRL0)                                  086126
      * UPD : Correspondent Details     Update index                                          086126
      *                                                                                       086126
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  086126
      **  Sar Text details                                                                    086126
      *                                                                                       086126
     D MMODDS        E DS                  EXTNAME(SDMMODPD)                                  086126
     D*                                                                                       086126
     D* Modules Data Structure *                                                              086126
     D*                                                                                       086126
     D RUNDTA        E DS                  EXTNAME(RUNDAT)                                    086126
     D*                                                                                       086126
     D* Get Rundate - Rundate  *                                                              086126
     D*                                                                                       086126
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)                                   086126
     D*                                                                                       086126
     D* Program data structure                                                                086126
     D*                                                                                       086126
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     086126
     I*                                                                                       086126
     I* Data Structures used by Access Programs                                               086126
     I*                                                                                       086126
     I*
      /EJECT
      *------------------------------------------------------------------*
      *                                                                  *
      *  Initial process - defines entry parameter list, key for client  *
      *                    file and reads client detail record.          *
      *                                                                  *
      *------------------------------------------------------------------*
      *
      ** Define entry parameter list.
      *
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7            RETURN CODE
     C*********************PARM           WCNUM   6                             CUSTOMER NO.  S01229
     C                   PARM                    WCUST             6            CUSTOMER NO.  S01229
     C*********************PARM           WCSNM  10                             SHORTNAME     S01229
     C                   PARM                    WCSSN            10            SHORTNAME     S01229
     C*********************PARM           WCTWN  10                             REPORT TOWN   S01229
     C                   PARM                    WCRTN            10            REPORT TOWN   S01229
     C*********************PARM           WBNST   1                             PARENT INDICATS01229
     C                   PARM                    WPAIN             1            PARENT INDICATS01229
     C                   PARM                    WCRNM            20            REPORT NAME
     C                   PARM                    WACOC             2            ACCOUNT OFFICER
     C*********************PARM           WCCTZ   2                             COUNTRY CITIZES01229
     C                   PARM                    WCNCZ             2            COUNTRY CITIZES01229
     C*********************PARM           WCLOC   2                             COUNTRY LOCATIS01229
     C                   PARM                    WCOLC             2            COUNTRY LOCATIOS0122
     C*********************PARM           WDASU   50                            SUSPENDED DATES01229
     C                   PARM                    WSSDT             5 0          SUSPENDED DATES01229
     C*********************PARM           WCDIC   50                            DATE FIRST CONS01229
     C                   PARM                    WDOIC             5 0          DATE FIRST CONS01229
     C*********************PARM           WCPAR   6                             PARENT NUMBER S01229
     C                   PARM                    WPCNB             6            PARENT NUMBER S01229
     C*********************PARM           WCASK   8                             SORT CODE     S01229
     C                   PARM                    WCASC             8            SORT CODE     S01229
     C                   PARM                    WBRCD             3            BRANCH CODE
     C*********************PARM           WBPST   1                             BANK/NON BANK S01229
     C                   PARM                    WBNBI             1            BANK/NON BANK S01229
     C*********************PARM           WLINS   2                             INSTITUTION   S01229
     C                   PARM                    WLINC             2            INSTITUTION   S01229
     C*********************PARM           WLIND   3                             INDUSTRY      S01229
     C                   PARM                    WLICD             3            INDUSTRY      S01229
     C*********************PARM           WTELF  12                             PHONE NUMBER  S01229
     C                   PARM                    WCTNB            12            PHONE NUMBER  S01229
     C*********************PARM           WRTID   4                             REUTER ID     S01229
     C                   PARM                    WREID             4            REUTER ID     S01229
     C*********************PARM           WCBSI   1                             BRANCH/SUBSID S01229
     C                   PARM                    WBSIN             1            BRANCH/SUBSID S01229
     C*********************PARM           WCTYP   1                             CUSTOMER TYPE S01229
     C                   PARM                    WCSTY             1            CUSTOMER TYPE S01229
     C*********************PARM           WBOST   1                             TAXABLE INDICAS01229
     C                   PARM                    WTAIN             1            TAXABLE INDICAS01229
     C                   PARM                    WCSID            12            SWIFT CODE
     C*********************PARM           WB5TX  12                             STTX ADDRESS  S01229
     C                   PARM                    WSTAD            12            STTX ADDRESS  S01229
     C*********************PARM           WCKTX  10                             TELEX ADDRESS1S01229
     C                   PARM                    WTXA1            10            TELEX ADDRESS1S01229
     C*********************PARM           WB1TX   60                            CHIPS ID      S01229
     C                   PARM                    WCHID             6 0          CHIPS ID      S01229
     C*********************PARM           WF7NB   60                            CHAPS SORT CODS01229
     C                   PARM                    WCHSC             6 0          CHAPS SORT CODS01229
     C*********************PARM           WB2TX   30                            CHIPS ABA     S01229
     C                   PARM                    WCABA             3 0          CHIPS ABA     S01229
     C                   PARM                    WRWCD             4            RISK WTG CODE RT0056
     C                   PARM                    WCGRP             1            CUSTOMER GROUPS01413
     C                   PARM                    WABA2             4 0          CHIPS 2 ABA   S01429
     C*********************PARM           WCHTP   1                             TYPE OF LST CHS01229
     C                   PARM                    WTYLC             1            TYPE OF LST CHS01229
     C                   PARM                    WLCD              5 0          LAST CHG DATE
     C*********************PARM           WRWCD   4                             RISK WTGS01267RT0056
     C                   PARM                    WGPC1             4            MARKETING GRP1S01267
     C                   PARM                    WGPC2             4            MARKETING GRP2S01267
     C                   PARM                    WGPC3             4            MARKETING GRP3S01267
     C                   PARM                    WGPC4             4            MARKETING GRP4S01267
     C                   PARM                    WGPC5             4            MARKETING GRP5S01267
     C                   PARM                    WLNID             2                        AR830675
     C                   PARM                    WCTYP            10                        AR830675
     C/COPY WNCPYSRC,SDCLINTC01
      *                                                                                       086126
      * Call initialise only once                                                             086126
      *                                                                                       086126
     C     #FIRST        IFNE      'Y'                                                        086126
     C                   EXSR      SRINIT                                                     086126
     C                   ENDIF                                                                086126
      *
      ** Define client file key.
      *
     C     CLKEY         KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    RCDT
      *
      ** Read client file detail record.
      *
     C*********************MOVE WCNUM     CNUM                                                S01229
     C                   MOVE      WCUST         CNUM                                         S01229
     C                   MOVE      'A'           RCDT
     C     CLKEY         CHAIN     CLINTCBF                           30
      *
      /EJECT
      *------------------------------------------------------------------*
      *                                                                  *
      *  Main process.                                                   *
      *                                                                  *
      *  Calls subroutines:   MAPDTA                                     *
      *                       ERROR                                      *
      *------------------------------------------------------------------*
      *
      ** Code for last change type - insert.
      *
     C***********WCHTP*****IFEQ 'I'                                                           S01229
     C     WTYLC         IFEQ      'I'                                                        S01229
      *
     C     *IN30         IFEQ      '1'
      ** Client detail record not found, therefore map data
     C                   EXSR      MAPDTA
      ** and write new record.
     C                   WRITE     CLINTCBF                             31
      ** Error on write.
     C     *IN31         IFEQ      '1'
     C                   EXSR      ERROR
     C                   END
      ** End of record not found code.
     C                   END
      *
     C     *IN30         IFEQ      '0'
      ** Record found
     C     RECI          IFEQ      '*'
      ** Record is a previous deletion, therefore map data
     C                   EXSR      MAPDTA
      ** and update existing record.
     C                   UPDATE    CLINTCBF                             32
     C                   END
      ** Record exists and not previous deletion or update fails,
     C     RECI          IFNE      '*'
     C     *IN32         OREQ      '1'
      ** therefore error.
     C                   EXSR      ERROR
     C                   END
      ** End of record found code.
     C                   END
      *                                                                                       086126
      * Write or Update Correspondence File if needed                                         086126
      *                                                                                       086126
     C     BGN1ST        IFEQ      'Y'                                                        086126
     C     CCG001        ANDEQ     'CCG001'                                                   086126
     C/COPY WNCPYSRC,SDCLINTC02
     C                   EXSR      SRCORR                                                     086126
     C                   ENDIF                                                                086126
      *                                                                                       086126
      ** End of change type - insert code.
     C                   END
      *
      ** Code for last change type - amend or delete.
      *
     C***********WCHTP*****IFEQ 'A'                                                           S01229
     C     WTYLC         IFEQ      'A'                                                        S01229
     C***********WCHTP*****OREQ 'D'                                                           S01229
     C     WTYLC         OREQ      'D'                                                        S01229
      *
      ** Record not found,
     C     *IN30         IFEQ      '1'
      ** therefore error.
     C                   EXSR      ERROR
     C                   END
      *
      ** Record found.
     C     *IN30         IFEQ      '0'
      ** But record previously deleted,
     C     RECI          IFEQ      '*'
      ** therefore error.
     C                   EXSR      ERROR
     C                   END
      *
      ** Record valid.
     C     RECI          IFEQ      'D'
      ** For last change type of amend, map data,
     C***********WCHTP*****IFEQ 'A'                                                           S01229
     C     WTYLC         IFEQ      'A'                                                        S01229
     C                   EXSR      MAPDTA
     C                   ELSE
      ** else, only update last change date and type.
     C                   MOVE      'C'           RECI
     C                   Z-ADD     WLCD          LCD
     C*********************MOVE WCHTP     CHTP                                                S01229
     C                   MOVE      WTYLC         CHTP                                         S01229
     C                   Z-ADD     WLCD          DADE                                         E18406
     C                   END
      ** Update record.
     C                   UPDATE    CLINTCBF                             32
     C     *IN32         IFEQ      '1'
      ** Error if update fails.
     C                   EXSR      ERROR
     C                   END
      ** End of record valid code.
     C                   END
     C/COPY WNCPYSRC,SDCLINTC09
      ** End of record found code.
     C                   END
     C/COPY WNCPYSRC,SDCLINTC07
      *
      ** End of change type amend/delete code.
     C                   END
      *
      /EJECT
      *------------------------------------------------------------------*
      *                                                                  *
      *  Final process - updates insert/delete/amend totals of client    *
      *                  file control record.                            *
      *  Calls subroutine :   ERROR                                      *
      *                                                                  *
      *------------------------------------------------------------------*
      *
     C**************       MOVE '000000'  CNUM                                                CSD027
     C                   MOVE      '      '      CNUM
     C                   MOVE      '0'           RCDT
     C     CLKEY         CHAIN     CLINTCAF                           33
     C     *IN33         IFEQ      '1'
      *
      ** Error in attempt to read record.
      *
     C                   EXSR      ERROR
     C                   END
      *
      ** Determine which total field to update, then update.
      *
      * Insert
     C***********WCHTP*****IFEQ 'I'                                                           S01229
     C     WTYLC         IFEQ      'I'                                                        S01229
     C                   ADD       1             TINS
     C                   END
      * Delete
     C***********WCHTP*****IFEQ 'D'                                                           S01229
     C     WTYLC         IFEQ      'D'                                                        S01229
     C                   ADD       1             TDEL
     C                   END
      * Amend
     C***********WCHTP*****IFEQ 'A'                                                           S01229
     C     WTYLC         IFEQ      'A'                                                        S01229
     C                   ADD       1             TAMD
     C                   END
     C/COPY WNCPYSRC,SDCLINTC06
      ** Update record.
     C                   UPDATE    CLINTCAF                             34
      *
     C     *IN34         IFEQ      '1'
      ** Error if update fails.
     C                   EXSR      ERROR
     C                   END
     C/COPY WNCPYSRC,SDCLINTC05
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      /EJECT
      *------------------------------------------------------------------*
      *  Index to subroutines.                                           *
      *                                                                  *
      *  MAPDTA - maps data from entry parameter list to CLINTCB fields. *
      *  ERROR  - sends error return message to calling programme.       *
      *                                                                  *
      *------------------------------------------------------------------*
      /EJECT
      *------------------------------------------------------------------*
      *                                                                  *
      *  MAPDTA subroutine - maps data from entry parameter list to      *
      *                      CLINTCB fields.                             *
      *  Called by main process.                                         *
      *                                                                  *
      *  Input  - *ENTRY PLIST.                                          *
      *  Output - CLINTCB fields.                                        *
      *                                                                  *
      *------------------------------------------------------------------*
      *
     C     MAPDTA        BEGSR
      *
     C                   MOVE      'D'           RECI
     C*********************MOVE WCNUM     CNUM                                                S01229
     C                   MOVE      WCUST         CNUM                                         S01229
     C                   MOVE      'A'           RCDT
     C                   MOVE      WCRNM         CRNM
     C*********************MOVE WCTWN     CTWN                                                S01229
     C                   MOVE      WCRTN         CTWN                                         S01229
     C*********************MOVE WCSNM     CSNM                                                S01229
     C                   MOVE      WCSSN         CSNM                                         S01229
     C*********************MOVE WCASK     CASK                                                S01229
     C                   MOVE      WCASC         CASK                                         S01229
     C*********************MOVELWCKTX     TELX                                                S01229
     C                   MOVEL     WTXA1         TELX                                         S01229
     C                   MOVEL     WCSID         CSID
     C                   MOVE      WACOC         ACOC
     C*********************MOVE WCBSI     CBSI                                                S01229
     C                   MOVE      WBSIN         CBSI                                         S01229
     C*********************MOVE WCCTZ     CCTZ                                                S01229
     C                   MOVE      WCNCZ         CCTZ                                         S01229
     C*********************MOVE WCLOC     CLOC                                                S01229
     C                   MOVE      WCOLC         CLOC                                         S01229
     C*********************MOVE WCPAR     CPAR                                                S01229
     C                   MOVE      WPCNB         CPAR                                         S01229
     C*********************MOVE WBRCD     BRCD                                                S01229
     C                   MOVE      WBRCD         BRCB                                         S01229
     C*********************MOVE WLINS     LINS                                                S01229
     C                   MOVE      WLINC         LINS                                         S01229
     C*********************MOVE WLIND     LIND                                                S01229
     C**********           MOVE WLICD     LIND                                      S01229 BUG23967B
     C                   MOVE      WLICD         LOIC                                      BUG23967B
     C*********************Z-ADDWDASU     DASU                                                S01229
     C                   Z-ADD     WSSDT         DASU                                         S01229
     C*********************Z-ADDWCDIC     CDIC                                                S01229
     C                   Z-ADD     WDOIC         CDIC                                         S01229
     C                   MOVEL     WRWCD         RWCD                                         S01267
     C                   MOVEL     WCGRP         CUGRP                                        S01413
     C                   MOVEL     WABA2         CAB2                                         S01429
     C                   MOVEL     WGPC1         GPC1                                         S01267
     C                   MOVEL     WGPC2         GPC2                                         S01267
     C                   MOVEL     WGPC3         GPC3                                         S01267
     C                   MOVEL     WGPC4         GPC4                                         S01267
     C                   MOVEL     WGPC5         GPC5                                         S01267
      *
     C***********WCHTP*****IFEQ 'D'                                                           S01229
     C     WTYLC         IFEQ      'D'                                                        S01229
     C                   Z-ADD     WLCD          DADE
     C                   END
      *
      ** Set of customer master indicators.
      *
     C                   BITOFF    '01234'       CMIN
     C***********WBPST*****IFEQ 'Y'                                                           S01229
     C     WBNBI         IFEQ      'Y'                                                        S01229
     C                   BITON     '0'           CMIN
     C                   END
     C***********WBOST*****IFEQ 'Y'                                                           S01229
     C     WTAIN         IFEQ      'Y'                                                        S01229
     C                   BITON     '1'           CMIN
     C                   END
     C***********WBNST*****IFEQ 'P'                                                           S01229
     C     WPAIN         IFEQ      'P'                                                        S01229
     C                   BITON     '2'           CMIN
     C                   END
      *
     C*********************MOVE WCTYP     CTYP                                                S01229
     C***********          MOVE WTYLC     CTYP                                         S01229 E38729
     C                   MOVE      WCSTY         CTYP                                         E38729
     C*********************MOVE WTELF     TELF                                                S01229
     C                   MOVE      WCTNB         TELF                                         S01229
     C*********************MOVELWB1TX     CHID                                                S01229
     C     WCHID         IFNE      *ZERO                                                      E30555
     C                   MOVEL     WCHID         CHID                                         S01229
     C                   ELSE                                                                 E30555
     C                   MOVEL     *BLANK        CHID                                         E30555
     C                   END                                                                  E30555
     C*********************MOVE WB2TX     CHAB                                                S01229
     C                   MOVE      WCABA         CHAB                                         S01229
     C*********************MOVE WCSNM     DRSN                                                S01229
     C                   MOVE      WCSSN         DRSN                                         S01229
      *
     C***********WCKTX*****IFNE *BLANKS                                                       S01229
     C     WTXA1         IFNE      *BLANKS                                                    S01229
     C                   MOVE      'T'           SWTX
     C                   END
      *
     C*********************MOVELWB5TX     STTX                                                S01229
     C                   MOVEL     WSTAD         STTX                                         S01229
      *
     C     CSID          IFNE      *BLANKS
     C***********WB5TX*****ORNE *BLANKS                                                       S01229
     C     WSTAD         ORNE      *BLANKS                                                    S01229
     C***********WCKTX*****ORNE *BLANKS                                                       S01229
     C     WTXA1         ORNE      *BLANKS                                                    S01229
     C                   MOVE      'Y'           GSFM
     C*************                                                                           E17239
     C                   ELSE
     C                   MOVE      *BLANKS       GSFM
     C*************                                                                           E17239
     C                   END
      *
     C*********************MOVE WRTID     RTID                                                S01229
     C                   MOVE      WREID         RTID                                         S01229
     C                   Z-ADD     WLCD          LCD
     C*********************MOVE WCHTP     CHTP                                                S01229
     C                   MOVE      WTYLC         CHTP                                         S01229
      *
     C                   ENDSR
      /EJECT
      *------------------------------------------------------------------*
      *                                                                  *
      *  ERROR subroutine - deals with CHAIN, WRITE and UPDATE errors.   *
      *                                                                  *
      *  Called by main process.                                         *
      *                                                                  *
      *  Output  - error flag to calling programme.                      *
      *------------------------------------------------------------------*
      *
     C     ERROR         BEGSR
      *
     C                   MOVE      '*ERROR*'     P0RTN
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C/COPY WNCPYSRC,SDCLINTC03
      *
     C                   ENDSR
      *                                                                                       086126
     C/EJECT                                                                                  086126
      *****************************************************************                       086126
      *                                                               *                       086126
      *  SRINIT   : Initialisation                                    *                       086126
      *                                                               *                       086126
      *  CALLED BY: Main processing                                   *                       086126
      *                                                               *                       086126
      *  CALLS    : None                                              *                       086126
      *                                                               *                       086126
      *****************************************************************                       086126
     CSR   SRINIT        BEGSR                                                                086126
      *                                                                                       086126
      *  Indicate that set up is complete                                                     086126
      *                                                                                       086126
     C                   MOVEL     'Y'           #FIRST            1                          086126
      *                                                                                       086126
      ** Check to see if User Defined Correspondance is installed.                            086126
      *                                                                                       086126
     C                   CALL      'AOMMODR0'                           9090                  086126
     C                   PARM      *BLANKS       ##RTCD            7            B:Return code 086126
     C                   PARM      '*FIRST '     ##OPTN            7            I:Option      086126
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg  086126
      *                                                                                       086126
      *  If return with an error (LR seton in called program) then                            086126
      *  process for database error.                                                          086126
      *                                                                                       086126
     C     *IN90         IFEQ      '1'                                                        086126
     C     ##RTCD        OREQ      '*ERROR*'                                                  086126
     C                   EXSR      ERROR                                                      086126
     C                   END                                                                  086126
      *                                                                                       086126
      *  Exit if UDC not installed                                                            086126
      *                                                                                       086126
     C     BGN1ST        CABNE     'Y'           EXINIT                                       086126
     C*                                                                                       086126
     C* Get Rundate - Rundate  *                                                              086126
     C*                                                                                       086126
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA                                       086126
     C                   IN        RUNDTA                                                     086126
      *                                                                                       086126
      **  Determine which SARs are in effect ...                                              086126
      **  ... 086126 - Write or Update Correspondent Details direct                           086126
     C                   CALL      'AOSARDR0'                           90                    086126
     C                   PARM      '       '     ##RTCD            7                          086126
     C                   PARM      '*VERIFY'     ##OPTN            7                          086126
     C***********          PARM '086126'  ##SARD  6                                    086126 086902
     C                   PARM      'CCG001'      ##SARD            6                          086902
     C     SCSARD        PARM      *BLANKS       DSFDY                                        086126
      *                                                                                       086126
      **  If the Access Object returns an error code, process a                               086126
      **  database error.                                                                     086126
     C     ##RTCD        IFNE      *BLANK                                                     086126
     C     ##RTCD        ANDNE     '*NRF   '                                                  086126
     C     *IN90         OREQ      *ON                                                        086126
     C                   EXSR      ERROR                                                      086126
     C                   ENDIF                                                                086126
      *                                                                                       086126
     C     ##RTCD        IFEQ      *BLANK                                                     086126
     C                   MOVEL     'CCG001'      CCG001            6                          086126
     C/COPY WNCPYSRC,SDCLINTC08
     C                   ENDIF                                                                086126
      *                                                                                       086126
      * Open CGCORRL0                                                                         086126
      *                                                                                       086126
     C                   OPEN      CGCORRL0                                                   086126
      *                                                                                       086126
     C     EXINIT        TAG                                                                  086126
      *                                                                                       086126
     CSR                 ENDSR                                                                086126
      *                                                                                       086126
     C/COPY WNCPYSRC,SDCLINTC04
     C/EJECT                                                                                  086126
      *****************************************************************                       086126
      *                                                               *                       086126
      *  SRCORR   : Update or Write Correspondent record              *                       086126
      *                                                               *                       086126
      *  CALLED BY: Main processing                                   *                       086126
      *                                                               *                       086126
      *  CALLS    : None                                              *                       086126
      *                                                               *                       086126
      *****************************************************************                       086126
     CSR   SRCORR        BEGSR                                                                086126
      *                                                                                       086126
      *  Access Correspondent file to see if exists or not                                    086126
      *                                                                                       086126
     C                   MOVEL(P)  WCUST         CDCORR                                       086126
      *                                                                                       086126
     C     CDCORR        CHAIN     @CORRL0                            90                      086126
     C/COPY WNCPYSRC,SDCLINTC10
      *                                                                                       086126
      * If live error                                                                         086126
      *                                                                                       086126
     C     *IN90         IFEQ      '0'                                                        086126
     C     CDRECI        ANDEQ     'D'                                                        086126
     C/COPY WNCPYSRC,SDCLINTC12
     C                   EXSR      ERROR                                                      086126
     C                   ENDIF                                                                086126
     C/COPY WNCPYSRC,SDCLINTC11
      *                                                                                       086126
      * Clear and set fields                                                                  086126
      *                                                                                       086126
     C                   CLEAR                   @CORRL0                                      086126
     C                   MOVEL(P)  WCUST         CDCORR                                       086126
     C                   MOVEL     'D'           CDRECI                                       086126
     C                   MOVEL     WCUST         CDCUST                                       086126
     C     WCTYP         IFEQ      *BLANKS                                                  AR830675
     C                   MOVEL     'DEFAULT'     CDCTYP                                       086126
     C                   ELSE                                                               AR830675
     C                   MOVEL     WCTYP         CDCTYP                                     AR830675
     C                   ENDIF                                                              AR830675
     C                   MOVEL     'C'           CDRTYP                                       086126
     C***********          MOVEL'GB'      CDLGID                                       086126 146789
     C**********           MOVEL'  '      CDLGID                                     146789 AR830675
     C                   MOVEL     WLNID         CDLGID                                     AR830675
     C*****WCRNM         CAT(P)    WCRTN         CDCORN                              086126 MD056543
     C                   EVAL      CDCORN = WCRNM + WCRTN                                   MD056543
     C                   Z-ADD     AGRDNB        CDCDTE                                       086126
     C                   MOVEL     'N'           CDPLAB                                       086126
     C                   Z-ADD     AGRDNB        CDATDT                                       086126
     C                   MOVEL     'Default'     CDCSTR                                       086126
     C     WCUST         CAT(P)    WCRNM         CDDESC                                       086126
     C                   MOVEL     ##JOB         CDAJOB                                       086126
     C                   MOVEL     ##USR         CDAUSR                                       086126
     C                   TIME                    CDATIM                                       086126
     C                   MOVEL     AGMRDT        CDARDT                                       086126
     C                   MOVEL     'I'           CDAACT                                       086126
     C                   Z-ADD     AGRDNB        CDRDNB                                       086126
      *                                                                                       086126
      *  Copy source for customer Specific changes                                            086126
      *                                                                                       086126
     C/COPY WNCPYSRC,SDCLINTCOR                                                               086126
      *                                                                                       086126
      * Write record if not found else update                                                 086126
      *                                                                                       086126
     C     *IN90         IFEQ      '1'                                                        086126
     C                   WRITE     @CORRL0                              90                    086126
     C                   ELSE                                                                 086126
     C                   UPDATE    @CORRL0                              90                    086126
     C                   ENDIF                                                                086126
      *                                                                                       086126
      * If error on update on write                                                           086126
      *                                                                                       086126
     C     *IN90         IFEQ      '1'                                                        086126
     C                   EXSR      ERROR                                                      086126
     C                   ENDIF                                                                086126
      *                                                                                       086126
     CSR                 ENDSR                                                                086126
      /EJECT
**CTDATA CPY@
(c) Finastra International Limited 2001
