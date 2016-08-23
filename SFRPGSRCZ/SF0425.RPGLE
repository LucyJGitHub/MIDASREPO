     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas SF Favourite items maintenance')                 *
      **********************************************************************
      *                                                                    *
      *  Midas - Security Profile Module                                   *
      *                                                                    *
      *  SF0425 - Favourite items maintenance                              *
      *                                                                    *
      *  Function:  This module maintain the entries in the favourite      *
      *             items file.                                            *
      *                                                                    *
      *  Called By: SF0420 - Midas user generated menu                     *
      *             SF0010 - Menu item maintenance                         *
      *             SF0028 - Midas user maintenance                        *
      *                                                                    *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                                    *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. 193389             Date 23Aug01                    *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSF001  *CREATE    Date 12JAN00                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  193389 - Program would return 'NOT FND' instead of 'ERROR'        *
      *           when a menu item to be deleted contains a blank          *
      *           'Item Code' field.                                       *
      *  CSF001 - Menu enhancements (Favourite menus, History)             *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      *  Use of indicators.                                                *
      *                                                                    *
      *    90         General Indicator                                    *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      *  S U B R O U T I N E  I N D E X                                    *
      *                                                                    *
      * *PSSR - Error processing                                           *
      * *INZSR - Initialise                                                *
      * AddFav - Add a favourite menu item                                 *
      * DelFav - Delete a favourite menu item                              *
      * WriteFav - Write a record in SFUFAVPD                              *
      * DeltFav1 - Delete a record in SFUFAVL1                             *
      * DeltFav2 - Delete a record in SFUFAVL2                             *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSFUFAVL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SFUFAVD0:SFUFAVD1)
     F                                     COMMIT
     FSFUFAVL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SFUFAVD0:SFUFAVD2)
     F                                     COMMIT
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
      ** ARRAYS
      ** ------
      ** Array of subroutines stack
     D SrStack         S             15    Dim(30)
 
      ** WORKING VARABLES
      ** ----------------
      ** Timestamp retrieved from module ZAGENTMSTM
     D TimestpSys      S             26
 
      ** INDEXES
      ** -------
     D q               S              2  0
 
      ** ENTRY PARAMETERS
      ** ----------------
     D ActionCode      S              1
     D UserId          S                   LIKE(UFUSRP)
     D ItemId          S                   LIKE(UFICDE)
     D MenuGroup       S                   LIKE(UFMGRP)
     D Timestamp       S                   LIKE(TimestpSys)
     D ReturnCode      S             10
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      **********************************************************************
      * MAIN PROCEDURE                                                     *
      **********************************************************************
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   MOVEA     'MAIN'        SrStack(q)
 
     C                   EVAL      ReturnCode =  *BLANK
 
     C                   SELECT
     C                   WHEN      ActionCode =  'I'
     C                   EXSR      AddFav
     C                   WHEN      ActionCode =  'D'
     C                   EXSR      DelFav
     C                   OTHER
     C                   EVAL      ReturnCode =  'ERROR'
     C                   ENDSL
 
     C                   IF        ReturnCode =  *BLANK
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
 
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
 
     C                   RETURN
 
      **********************************************************************
      *                                                                    *
      * *PSSR  - Program exception error routine                           *
      *          Called automatically if a program error occurs,           *
      *          or directly by the program code using EXSR.               *
      *          This subroutine DUMPs the program just once.              *
      *                                                                    *
      * Called by: (**calling routines**)                                  *
      *                                                                    *
      **********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      **********************************************************************
      * *INZSR - INITIAL PROCESSING                                        *
      **********************************************************************
     C     *INZSR        BEGSR
 
      ** +--------------------------------------+
      ** ¦ PARAMETERS                           ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     C     *ENTRY        PLIST
     C                   PARM                    ActionCode
     C                   PARM                    UserId
     C                   PARM                    ItemId
     C                   PARM                    MenuGroup
     C                   PARM                    Timestamp
     C                   PARM                    ReturnCode
 
      ** +--------------------------------------+
      ** ¦ KEYS DEFINITION                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     C     KeyFav1       KLIST
     C                   KFLD                    UserId
     C                   KFLD                    Timestamp
     C     KeyFav2       KLIST
     C                   KFLD                    MenuGroup
     C                   KFLD                    ItemId
     C     KeyFav3       KLIST
     C                   KFLD                    UserId
 
      ** Read in Installation Data
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
     C                   ENDSR
      **********************************************************************
      * AddFav - Add a favourite menu item                                 *
      **********************************************************************
     C     AddFav        BEGSR
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   MOVEA     'AddFav'      SrStack(q)
 
     C                   EVAL      ReturnCode =  'ERROR'
 
      ** Case 1 : a menu item has been added in the favourites list
     C                   IF        UserId <> *BLANK AND
     C                             ItemId <> *BLANK AND
     C                             MenuGroup <> *ZEROS AND
     C                             (Timestamp = *ZEROS OR Timestamp = *BLANK)
 
      ** Get timestamp
     C                   CALLB     'ZAGENTMSTM'                         90
     C                   PARM                    TimestpSys
     C                   IF        *IN90
     C                   EVAL      DBFILE = 'ZAGENTMSTM'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      UFRECI = 'D'
     C                   EVAL      UFUSRP = UserId
     C                   EVAL      UFTSMP = TimestpSys
     C                   EVAL      UFMGRP = MenuGroup
     C                   EVAL      UFICDE = ItemId
     C                   EXSR      WriteFav
 
     C                   EVAL      ReturnCode =  *BLANK
 
     C                   ENDIF
 
      **  Unwind subroutine stack name
     C     E_AddFav      TAG
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
 
     C                   ENDSR
      **********************************************************************
      * DelFav - Delete a favourite menu item                              *
      **********************************************************************
     C     DelFav        BEGSR
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   MOVEA     'DelFav'      SrStack(q)
 
     C                   EVAL      ReturnCode =  'ERROR'
 
      ** Case 1 : a user has been deleted
     C                   IF        UserId <> *BLANK AND
     C                             ItemId = *BLANK AND
     C                             (Timestamp = *ZEROS OR Timestamp = *BLANK)
 
     C     KeyFav3       SETLL     SFUFAVL1                               90
     C                   IF        NOT *IN90
     C                   EVAL      ReturnCode =  'NOT FND'
     C                   GOTO      E_DelFav
     C                   ENDIF
 
     C     KeyFav3       READE     SFUFAVL1                               90
     C                   IF        *IN90
     C                   EVAL      ReturnCode =  'NOT FND'
     C                   GOTO      E_DelFav
     C                   ENDIF
 
     C                   DOW       *IN90 = '0'
     C                   EXSR      DeltFav1
     C     KeyFav3       READE     SFUFAVL1                               90
     C                   ENDDO
 
     C                   EVAL      ReturnCode =  *BLANK
     C                   GOTO      E_DelFav
     C                   ENDIF
 
      ** Case 2 : a menu item has been deleted
     C                   IF        UserId = *BLANK AND
     C**********                   ItemId <> *BLANK AND                                       193389
     C                             MenuGroup <> *ZEROS AND
     C                             (Timestamp = *ZEROS OR Timestamp = *BLANK)
 
     C     KeyFav2       SETLL     SFUFAVL2                               90
     C                   IF        NOT *IN90
     C                   EVAL      ReturnCode =  'NOT FND'
     C                   GOTO      E_DelFav
     C                   ENDIF
 
     C     KeyFav2       READE     SFUFAVL2                               90
     C                   IF        *IN90
     C                   EVAL      ReturnCode =  'NOT FND'
     C                   GOTO      E_DelFav
     C                   ENDIF
 
     C                   DOW       *IN90 = '0'
     C                   EXSR      DeltFav2
     C     KeyFav2       READE     SFUFAVL2                               90
     C                   ENDDO
 
     C                   EVAL      ReturnCode =  *BLANK
     C                   GOTO      E_DelFav
     C                   ENDIF
 
      ** Case 3 : a favourite menu item  has been deleted
     C                   IF        UserId <> *BLANK AND
     C                             ItemId = *BLANK AND
     C                             MenuGroup = *ZEROS AND
     C                             Timestamp <> *ZEROS  AND
     C                             Timestamp <> *BLANK
 
     C     KeyFav1       CHAIN     SFUFAVL1                           90
     C                   IF        *IN90
     C                   EVAL      ReturnCode =  'NOT FND'
     C                   GOTO      E_DelFav
     C                   ENDIF
     C                   EXSR      DeltFav1
 
     C                   EVAL      ReturnCode =  *BLANK
     C                   GOTO      E_DelFav
     C                   ENDIF
 
      **  Unwind subroutine stack name
     C     E_DelFav      TAG
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
 
     C                   ENDSR
      **********************************************************************
      * WriteFav - Write a record in SFUFAVPD                              *
      **********************************************************************
     C     WriteFav      BEGSR
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   MOVEA     'WriteFav'    SrStack(q)
 
     C                   WRITE     SFUFAVD1                             90
 
     C                   IF        *IN90
     C                   EVAL      DBFILE = 'SFUFAVPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = '*WRITE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
 
     C                   ENDSR
      **********************************************************************
      * DeltFav1  - Delete a record in SFUFAVL1                            *
      **********************************************************************
     C     DeltFav1      BEGSR
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   MOVEA     'DeltFav1'    SrStack(q)
 
     C                   DELETE    SFUFAVD1                             90
 
     C                   IF        *IN90
     C                   EVAL      DBFILE = 'SFUFAVL1'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = '*DELETE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
 
     C                   ENDSR
      **********************************************************************
      * DeltFav2  - Delete a record in SFUFAVL2                            *
      **********************************************************************
     C     DeltFav2      BEGSR
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   MOVEA     'DeltFav2'    SrStack(q)
 
     C                   DELETE    SFUFAVD2                             90
 
     C                   IF        *IN90
     C                   EVAL      DBFILE = 'SFUFAVL2'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = '*DELETE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
 
     C                   ENDSR
