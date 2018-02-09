     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Initialise SDBANKPD for CDL008')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0069 - Initialise SDBANKPD for CDL008                      *
      *                                                               *
      *  Function:  This program initialises SDBANKPD for the CDL008  *
      *             rewlated fields.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 210377  *CREATE    Date 07Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  210377 - New initialisation program missing from CDL008.     *
      *                                                               *
      *****************************************************************
      *
     FSDBRCHPD  UF   E           K DISK
      ** Branch codes file
 
     D PSDS           SDS
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
 
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    RETCDE            7
     C                   PARM                    PMODE             1
 
      ** If the program is running in Mode 1 (1st switch on).
 
     C     PMODE         IFEQ      '1'
     C                   EXSR      BRCHSR
     C                   ENDIF
 
      ** If the program is running in Mode 2 (2nd switch on).
 
     C     PMODE         IFEQ      '2'
     C                   EXSR      BRCHSR
     C                   ENDIF
 
      * If the program is running in Mode 1 (switch off).
 
     C     PMODE         IFEQ      '3'
      *          No processing required.
     C                   ENDIF
 
     C                   SETON                                            LR
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * BRCHSR - SDBRCHPD Initialisation Routine                      *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     BRCHSR        BEGSR
 
     C                   READ      SDBRCHPD                               04
 
     C     *IN04         DOWEQ     '0'
 
      * If 'Default CLS by Customer' field is blank then initialise
      * to 'N'.
     C     A8DCLC        IFEQ      ' '
     C                   MOVE      'N'           A8DCLC
     C                   ENDIF
 
      * If 'Time Difference from CET' field is blank then initialise
      * to '0000+'.
     C     A8TDCE        IFEQ      ' '
     C                   MOVE      '0000+'       A8TDCE
     C                   ENDIF
 
     C                   UPDATE    SDBRCHD0
 
     C                   READ      SDBRCHPD                               04
 
     C                   END
 
     C                   ENDSR
 
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
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
 
     C                   SETON                                        U7U8LR
     C                   MOVEL     'FAILURE'     RETCDE
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
