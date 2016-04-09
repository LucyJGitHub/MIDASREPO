     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Convert (8,0) date to (6,0)')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZA0770 - Convert (8,0) date to (6,0)                         *
      *                                                               *
      *  Function:  This module accepts an (8,0) number containing a  *
      *             date in the form YYYYMMDD, and returns a (6,0)    *
      *             date in either DDMMYY or MMDDYY, depending on     *
      *             another parameter.                                *
      *                                                               *
      *             This was originally a subroutine which was        *
      *             repeated in each of the MM deals input programs   *
      *             (and possibly elsewhere).  The section which was  *
      *             copied from MM0089 is clearly marked, and has not *
      *             been modified; code has been added around it      *
      *             to turn this into a compilable module.            *
      *                                                               *
      *  Component of: ZA_ALL - All ZA modules service program        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--- Start of D-specs converted from MM0089 ---------------------+
 
     D                 DS
     D**  Data structure for date in, to change format.
     D  @@DTIN                 1      8  0
     D  @@YY                   3      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
     D*
     D                 DS             6
     D**  Data structure to change format to MMDDYY/DDMMYY
     D  @@DTOU                 1      6  0
     D  @@DAT1                 1      2  0
     D  @@DAT2                 3      4  0
     D  @@YYY                  5      6  0
 
      ** +--- End of D-specs converted from MM0089 -----------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Date in
     D DateIn          S              8S 0
 
      ** Date out
     D DateOut         S              6P 0
 
      ** Date format (the stupid name is kept for compatibility with the old
      ** code).
     D BJDFIN          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Copy the received parameter to the subroutine field
     C                   EVAL      @@DTIN = DateIn
 
      ** Pass control to the old subroutine
     C                   EXSR      ZA0770
 
      ** Copy the converted date to the parameter to return, and exit
     C                   EVAL      DateOut = @@DTOU
 
     C                   RETURN
 
      ** +--- Start of subroutine code copied from MM0089 ----------------+
 
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE ZA0770 - THIS SUBROUTINE RECEIVES A 8/0 INPUT     *
     C*                      DATE - FORMAT YYYYMMDD AND OUTPUTS A     *
     C*                      6/0 DATE. IF FIELD DATE FORMAT (SDBANKPD)*
     C*                      'M' OUTPUT FORMAT MMDDYY. IF DATE        *
     C*                      FORMAT = 'D' OUTPUT FORMAT DDMMYY.       *
     C*                                                               *
     C*  CALLED BY   :                                                *
     C*                                                               *
     C*  INPUT       : @@DTIN  - DATE INPUT (8,0)                     *
     C*  OUTPUT      : @@DTOU  - DATE OUTPUT (6,0)                    *
     C*                                                               *
     C*  WORK FIELDS : @@YYY   - YEAR IN (2,0)                        *
     C*              : @@MM    - MONTH IN (2,0)                       *
     C*              : @@DD    - DAY IN (2,0)                         *
     C*                                                               *
     C*              : @@DAT1  - IF DATE DD/MM/YY DAY ELSE MONTH (2,0)*
     C*              : @@DAT2  - IF DATE DD/MM/YY MONTH ELSE DAY (2,0)*
     C*                                                               *
     C*****************************************************************
     C     ZA0770        BEGSR
     C*
     C                   Z-ADD     @@YY          @@YYY
     C*
     C**  DATE FORMAT = 'D' CONVERT TO MMDDYY FORMAT
     C     BJDFIN        IFEQ      'D'
     C                   Z-ADD     @@DD          @@DAT1
     C                   Z-ADD     @@MM          @@DAT2
     C                   END
     C*
     C*
     C**  DATE FORMAT = 'M' CONVERT TO MMDDYY FORMAT
     C     BJDFIN        IFEQ      'M'
     C                   Z-ADD     @@DD          @@DAT2
     C                   Z-ADD     @@MM          @@DAT1
     C                   END
     C*
     C**  MOVE YEAR PART OF DATA STRUCTURE
     C                   MOVE      @@YYY         @@YY
     C*
     C     ZA0779        ENDSR                                                  ***ZA0779***
 
      ** +--- End of subroutine code copied from MM0089 ------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    DateIn
     C                   PARM                    BJDFIN
     C                   PARM                    DateOut
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
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
      * Called by:                                                    *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *blank
     C                   MOVE      'Y'           RunBefore
     C                   DUMP
 
     C                   CALLB     DBErrCtl
 
      ********************************************************************
     C                   ENDIF
 
     C                   EVAL       *inu7 = *inu8 = *on
     C                   EVAL       *inlr = *on
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
