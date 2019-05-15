     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP FF Instruments - Take on')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian DBA Replication                             *
      *                                                               *
      *  RP1469 - FF Instruments Take On                              *
      *                                                               *
      *  Function:  This program sends journal entries via RPC1482    *
      *  (I/C)      for each instrument type in INTYPD so that        *
      *             historic rates and types could be built.          *
      *                                                               *
      *  Component of: RPC1469 - FF Instruments Take On               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80         End of file INTYPD                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR   - Program exception error routine                    *
      *  *INZSR  - Program Initialization routine.                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FINTYPD    IF   E             DISK    INFSR(*PSSR)
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** External Data structure for Local data area (db error details).
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D WEDsINTYPD    E DS                  EXTNAME(INTYPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRunBefore      S              1A
     D PRtnCde         S              7A
     D POption         S              7A
     D PEntry          S           3000A
     D PFile           S             10A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *INZSR is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
      **---------------------------------------**
      ** Instrument processing type 1, 2, 3, 7 **
      **---------------------------------------**
 
     C     1             SETLL     INTYPD
     C                   READ      INTYPD                                 80
 
     C     *IN80         DOWEQ     *OFF
 
     C     ISPT          IFEQ      1
     C     ISPT          OREQ      2
     C     ISPT          OREQ      3
     C     ISPT          OREQ      7
 
     C     RECI          IFEQ      'D'
     C                   MOVEL     *BLANKS       PEntry
     C                   MOVEL     *BLANKS       PFile
     C                   CALL      'RPC1482'
     C                   PARM      WEDsINTYPD    PEntry
     C                   PARM      'INTYPD'      PFile
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      INTYPD                                 80
 
     C                   ENDDO
 
      **---------------------------------------**
      ** Other than processing type 1, 2, 3, 7 **
      **---------------------------------------**
 
     C     1             SETLL     INTYPD
     C                   READ      INTYPD                                 80
 
     C     *IN80         DOWEQ     *OFF
 
     C     ISPT          IFNE      1
     C     ISPT          ANDNE     2
     C     ISPT          ANDNE     3
     C     ISPT          ANDNE     7
     C     RECI          ANDEQ     'D'
     C                   MOVEL     *BLANKS       PEntry
     C                   MOVEL     *BLANKS       PFile
     C                   CALL      'RPC1482'
     C                   PARM      WEDsINTYPD    PEntry
     C                   PARM      'INTYPD'      PFile
     C                   ENDIF
 
     C                   READ      INTYPD                                 80
 
     C                   ENDDO
 
      ** Terminate program
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR  - Program Initialization routine.                    *
      *                                                               *
      *  Called By: Implicitly on program activation.                 *
      *                                                               *
      *  Calls:     AOBANKR0, *PSSR                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialize program name
     C                   MOVEL     'RP1469'      DBPGM
 
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     PRtnCde       IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     POption       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     DBERRCTL                                          *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     WRunBefore    IFNE      'Y'
     C                   EVAL      WRunBefore = 'Y'
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
