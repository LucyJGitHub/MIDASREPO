      *****************************************************************
/*S*D ***RPGBASEMOD****************************************************                       CAP084
/*STD *  RPGBASEBND                                                   *                       CAP084
/*EXI *  DFTACTGRP(*NO) ACTGRP(*CALLER)                               *                       CAP084
/*EXI *  TEXT('Midas BU Base rates background update program')
      *****************************************************************
      *                                                               *
      *  Midas Standing Data Module                                   *
      *                                                               *
      *  TABLETK - BACKGROUND UPDATE OF TABLETK FILE                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MG000484      Date 20Mar18                    *      
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP084             Date 27Feb03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 E19243             Date 19Jun90               *
      *                 S01251        Date 03Feb90                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MG000484 - Rate Change should not be generated if New Base   *
      *             Rate has the same vaule as the previous history   *
      *             record.                                           *
      *           - Applied for MD-49833.                             *      
      *  MD046248 - Finastra Rebranding                               *
      *  CAP084 - Wrapper project - convert to ILE                    *
      *  E19243 - SET ON RCIN FOR NEW RATES.                          *
      *  S01251 - SYNON FIELD NAME CHANGES                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       30      CHAIN TABLETK FAILED/ERROR                      *
      *       31      ERROR ON TABLETK FILE                           *
      *       32      CHAIN TABLETX FAILED/ERROR                      *
      *                                                               *
      *****************************************************************
     FTABLETK   UF A E           K DISK
     F                                     COMMIT
     FTABLETA   UF   E           K DISK
     F                                     COMMIT
     FTABLETXL  UF   E           K DISK
     F                                     COMMIT
      /EJECT
     I*
     I* RENAME RECORD ID ON HEADER FILE TO AVOID OVERWRITING
     I*
     ITABLETAF
     I              RECT                        RECTA
      /EJECT
     C*
     C     KKEY          KLIST
     C                   KFLD                    KCCY
     C                   KFLD                    KBRTT
     C*
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7            RETURN CODE
     C*********************PARM           WCCY    3        CURRENCY       S01251
     C*********************PARM           WBRTT   2        BASE RATE CO   S01251
     C*********************PARM           WBRTE  117       CURR. BASE R   S01251
     C                   PARM                    WCYCD             3            CURRENCY       S0125
     C                   PARM                    WBSRC             2            BASE RATE CO   S0125
     C                   PARM                    WCBSR            11 7          CURR. BASE R   S0125
     C                   PARM                    WVDRC             5 0          VD OF RATE
     C*********************PARM           WBRTN  30        B RATE NAME    S01251
     C                   PARM                    WBSRN            30            B RATE NAME    S0125
     C                   PARM                    WNBRT            11 7          NEW BASE R
     C                   PARM                    WVDNR             5 0          NEW VD OF R
     C*********************PARM           WFSRT   5        BASE S'NAME    S01251
     C*********************PARM           WCHTP   1        LAST CHANGE TYPS01251
     C                   PARM                    WBSRS             5            BASE S'NAME    S0125
     C                   PARM                    WTYLC             1            LAST CHANGE TYPS0125
     C                   PARM                    WLCD              5 0          LAST CHANGE DAT
     C                   PARM                    WACRC             1                        MG000484
     C     *LIKE         DEFINE    CCY           KCCY                           KEY TO FILE
     C     *LIKE         DEFINE    BRTT          KBRTT                          KEY TO FILE
     C*
      /EJECT
     C****************************************************************
     C*
     C*   M A I N L I N E   P R O G R A M
     C*
     C****************************************************************
     C*
     C* IF RECORD HAS BEEN INSERTED, CHAIN TO TABLETK TO CHECK THAT
     C* RECORD DOES NOT ALREADY EXIST ON THIS FILE
     C*
     C***********WCHTP     IFEQ 'I'                                       S01251
     C     WTYLC         IFEQ      'I'                                                         S0125
     C*********************MOVE WCCY      KCCY                            S01251
     C*********************MOVE WBRTT     KBRTT                           S01251
     C                   MOVE      WCYCD         KCCY                                          S0125
     C                   MOVE      WBSRC         KBRTT                                         S0125
     C     KKEY          CHAIN     TABLETK                            30        CHAIN FAILED
     C*
     C* IF RECORD DOES NOT EXIST
     C* THEN MOVE PARAMETERS RECIEVED INTO FILE FIELDS AND WRITE
     C* A NEW RECORD
     C*
     C     *IN30         IFEQ      '1'
     C*
     C* IF IT DOES EXIST AS DELETED(RECI *)
     C* THEN MOVE PARAMETERS RECIEVED INTO FILE FIELDS AND UPDATE
     C* OLD RECORD
     C*
     C     *IN30         OREQ      '0'
     C     RECI          ANDEQ     '*'
     C                   MOVE      'D'           RECI
     C                   Z-ADD     21            RECT
     C*********************MOVE WCCY      CCY              CURRENCY       S01251
     C*********************MOVE WBRTT     BRTT             BASE RATE CO   S01251
     C*********************Z-ADDWBRTE     BRTE             CURR. BASE R   S01251
     C                   MOVE      WCYCD         CCY                            CURRENCY       S0125
     C                   MOVE      WBSRC         BRTT                           BASE RATE CO   S0125
     C                   Z-ADD     WCBSR         BRTE                           CURR. BASE R   S0125
     C                   Z-ADD     WVDRC         VDRC                           VD OF RATE
     C*********************MOVE WBRTN     BRTN             B RATE NAME    S01251
     C                   MOVE      WBSRN         BRTN                           B RATE NAME    S0125
     C                   Z-ADD     WNBRT         NBRT                           NEW BASE R
     C                   Z-ADD     WVDNR         VDNR                           NEW VD OF R
     C*********************MOVE WFSRT     FSRT             BASE S'NAME    S01251
     C*********************MOVE WCHTP     CHTP                            S01251
     C                   MOVE      WBSRS         FSRT                           BASE S'NAME    S0125
     C                   MOVE      WTYLC         CHTP                                          S0125
     C                   Z-ADD     WLCD          LCD
     C                   BITON     '01234567'    RCIN                           BASE RATE IND  E1924
     C*
     C* IF RECORD FOUND ON FILE AND IS NOT A DELETED RECORD SET ERROR
     C*
     C                   ELSE
     C*
     C                   SETON                                        31
     C                   END
     C*
     C     *IN30         IFEQ      '1'
     C                   WRITE     TABLETKF                             31       ERROR
     C                   END
     C*
     C     *IN30         IFEQ      '0'
     C     *IN31         ANDEQ     '0'
     C                   UPDATE    TABLETKF                             31       ERROR
     C                   END
     C*
     C     *IN31         IFEQ      '1'
     C                   MOVE      '*ERROR*'     P0RTN
     C                   END
     C*
     C* RECORD IS NOT AN INSERT
     C*
     C                   END
     C*
     C* IF RECORD HAS BEEN CHANGED, RETRIEVE RECORD FROM FILE
     C*
     C***********WCHTP     IFEQ 'A'                                       S01251
     C*********************MOVE WCCY      KCCY                            S01251
     C*********************MOVE WBRTT     KBRTT                           S01251
     C     WTYLC         IFEQ      'A'                                                         S0125
     C                   MOVE      WCYCD         KCCY                                          S0125
     C                   MOVE      WBSRC         KBRTT                                         S0125
     C     KKEY          CHAIN     TABLETKF                           30        CHAIN FAILED
     C*
     C* IF RECORD FOUND, MOVE RECEIVED PARAMETERS INTO FILE FIELDS
     C* AND UPDATE
     C*
     C     *IN30         IFEQ      '0'
     C*********************MOVE WCCY      CCY              CURRENCY       S01251
     C*********************MOVE WBRTT     BRTT             BASE RATE CO   S01251
     C*********************Z-ADDWBRTE     BRTE             CURR. BASE R   S01251
     C*********************MOVE WCYSD     CCY              CURRENCY       S01251
     C                   MOVE      WCYCD         CCY                            CURRENCY       S0125
     C                   MOVE      WBSRC         BRTT                           BASE RATE CO   S0125
     C                   Z-ADD     WCBSR         BRTE                           CURR. BASE R   S0125
     C                   Z-ADD     WVDRC         VDRC                           VD OF RATE
     C*********************MOVE WBRTN     BRTN             B RATE NAME    S01251
     C                   MOVE      WBSRN         BRTN                           B RATE NAME    S0125
     C                   Z-ADD     WNBRT         NBRT                           NEW BASE R
     C                   Z-ADD     WVDNR         VDNR                           NEW VD OF R
     C*********************MOVE WFSRT     FSRT             BASE S'NAME    S01251
     C*********************MOVE WCHTP     CHTP                            S01251
     C                   MOVE      WBSRS         FSRT                           BASE S'NAME    S0125
     C                   MOVE      WTYLC         CHTP                                          S0125
     C                   Z-ADD     WLCD          LCD
     C                   BITON     '01234567'    RCIN                           BASE RATE IND  E1507
     C     WACRC         IFEQ      'N'                                                      MG000484
     C                   BITOFF    '3'           RCIN                                       MG000484
     C                   ENDIF                                                              MG000484
     C                   UPDATE    TABLETKF                             30      ERROR
     C                   END
     C*
     C* IF RECORD NOT FOUND OR ERROR OCCURRED ON UPDATE SET ERROR
     C* PARAMETER
     C*
     C     *IN30         IFEQ      '1'
     C                   MOVE      '*ERROR*'     P0RTN
     C                   END
     C*
     C* RECORD IS NOT A CHANGED RECORD
     C*
     C                   END
     C*
     C* IF RECORD HAS BEEN DELETED FROM THE NEW FILE, RETRIEVE IT
     C* FROM TABLETK
     C*
     C***********WCHTP     IFEQ 'D'                                       S01251
     C*********************MOVE WCCY      KCCY                            S01251
     C*********************MOVE WBRTT     KBRTT                           S01251
     C     WTYLC         IFEQ      'D'                                                         S0125
     C                   MOVE      WCYCD         KCCY                                          S0125
     C                   MOVE      WBSRC         KBRTT                                         S0125
     C     KKEY          CHAIN     TABLETKF                           30        CHAIN FAILED
     C*
     C* IF RECORD FOUND, UPDATE RELEVANT FIELDS (WE DON'T ACTUALLY
     C* DELETE ANY RECORDS FROM THE OLD FILES)
     C*
     C     *IN30         IFEQ      '0'
     C                   MOVE      '*'           RECI
     C*********************MOVE WCHTP     CHTP                            S01251
     C                   MOVE      WTYLC         CHTP                                          S0125
     C                   Z-ADD     WLCD          LCD
     C                   UPDATE    TABLETKF                             30      ERROR
     C                   END
     C*
     C* IF RECORD NOT FOUND OR ERROR OCCURRED ON UPDATE SET ERROR
     C* PARAMETER
     C*
     C     *IN30         IFEQ      '1'
     C                   MOVE      '*ERROR*'     P0RTN
     C                   END
     C*
     C                   END
     C*
     C* IF NO ERRORS HAVE OCCURRED ON TABLETK UPDATE
     C*
     C     P0RTN         IFEQ      *BLANKS
     C*
     C* RETRIEVE OLD TRAILER FILE RECORD
     C*
     C     '21'          CHAIN     TABLETXF                           32        CHAIN FAILED
     C*
     C* IF CHAIN TO FILE SUCCESSFUL
     C*
     C     *IN32         IFEQ      '0'
     C*
     C* IF FIRST ACCESS TO THE FILE THEN GET HEADER RECORD
     C*
     C     NINS          ANDEQ     0
     C     NAMD          ANDEQ     0
     C     NDEL          ANDEQ     0
     C*
     C                   READ      TABLETAF                               32      EOF
     C*
     C* IF HEADER RECORD FOUND THEN SET PRINT INDICATOR AND UPDATE
     C*
     C     *IN32         IFEQ      '0'
     C                   ADD       1             IBSR
     C                   UPDATE    TABLETAF                             32        ERROR
     C                   END
     C*
     C                   END
     C*
     C* IF NO ERRORS
     C*
     C     *IN32         IFEQ      '0'
     C*
     C* UPDATE AS APPROPRIATE THE NUMBER OF INSERTS,AMENDS OR DELETES
     C* ON THE TRAILER FILE
     C*
     C***********WCHTP     IFEQ 'I'                                       S01251
     C     WTYLC         IFEQ      'I'                                                         S0125
     C                   ADD       1             NINS
     C                   END
     C*
     C***********WCHTP     IFEQ 'A'                                       S01251
     C     WTYLC         IFEQ      'A'                                                         S0125
     C                   ADD       1             NAMD
     C                   END
     C*
     C***********WCHTP     IFEQ 'D'                                       S01251
     C     WTYLC         IFEQ      'D'                                                         S0125
     C                   ADD       1             NDEL
     C                   END
     C*
     C                   UPDATE    TABLETXF                             32        ERROR
     C*
     C                   END
     C*
     C* CHECK FOR ANY ERRORS AND SET ERROR PARAMETER FOR RETURN TO
     C* NEW FILE MAINTENANCE PROGRAM
     C*
     C     *IN32         IFEQ      '1'
     C                   MOVE      '*ERROR*'     P0RTN
     C                   END
     C*
     C                   END
     C*
     C                   SETON                                        LR
     C                   RETURN
     C*
