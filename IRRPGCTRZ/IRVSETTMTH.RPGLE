     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate Settlement Methods')
      *****************************************************************
      *                                                               *
      *  Midas - IRS Validation Module                                *
      *                                                               *
      *  IRVSETTMTH - Validate settlement methods.                    *
      *                                                               *
      *  Function:  This module receives parameters containing the    *
      *             payment and receipt settlement methods and        *
      *             confirms whether they have a valid value. If it is*
      *             valid the 10A return code will be blank; if it is *
      *             not it will contain 'Error'                       *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP003  *CREATE    Date 01Feb98               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Receipt Settlemet method passed as a parameter from calling program
     D   SRSETM        S              2A
 
      ** Payment settlement method passed as a parameter from calling program
     D   SPSETM        S              2A
 
      ** Currency passed as a parameter from calling program
     D SUCUCY          S              3A
 
      ** US Dollar currency code passed as a parameter from calling program
     D  BLUSCY         S              3A
 
      ** Retail account number used in system indicator passes as a parameter from calling prg
     D  IND88          S              1A
 
      ** Retail module present in system indicator passed as parameter from calling program
     D  IND89          S              1A
 
      ** Retail module indicator (Y or N) Y if present
     D  BGRTBN         S              1A
 
      ** Query field
     D  @QMARK         S              1A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Validation error indicator used within module
     D  Mistake1       S              1A
 
      ** Validation error indicator used within module
     D  Mistake2       S              1A
 
      ** Error message passed back to calling program
     D  Msgid1         S                   LIKE(#Msgid)
 
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
 
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   MOVE      'N'           Mistake1
     C                   MOVE      'N'           Mistake2
      *
      ** Validate Receipt Settlement Method.
     C     SRSETM        IFNE      *BLANKS
      *
     C* ENQUIRY NOT ALLOWED FOR SETTLEMENT INSTRUCTIONS
     C*
     C                   MOVEL     SRSETM        @QMARK
     C     @QMARK        IFEQ      '?'
 
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0048'     Msgid1
     C                   MOVE      'Y'           Mistake1
     C                   END
     C*
     C     SRSETM        IFLT      '00'
     C     SRSETM        ORGT      '08'
      *
     C     SRSETM        ANDNE     '12'
     C     SRSETM        ANDNE     '14'
 
     C     Mistake1      IFNE      'Y'
     C*
     C* If enquiry error already, don't write validation error
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0044'     Msgid1
     C                   MOVE      'Y'           Mistake1
     C                   END
      *
     C                   END
      *
     C     Mistake1      IFEQ      'N'
      *
     C     SRSETM        IFEQ      '04'
     C     SRSETM        OREQ      '14'
      *
     C     IND89         IFEQ      '0'
     C     BGRTBN        OREQ      'N'
 
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0045'     Msgid1
     C                   MOVE      'Y'           Mistake1
     C                   END
     C                   END
     C                   END
     C*
     C/COPY WNCPYSRC,DL1602IVS3
     C*
      *
     C     Mistake1      IFEQ      'N'
     C     IND88         ANDEQ     '0'
     C     SRSETM        ANDEQ     '14'
 
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0046'     Msgid1
     C                   MOVE      'Y'           Mistake1
     C                   END
      *
     C     Mistake1      IFEQ      'N'
     C     SUCUCY        ANDNE     BLUSCY
     C     SRSETM        ANDEQ     '07'
 
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0047'     Msgid1
     C                   MOVE      'Y'           Mistake1
     C                   END
      *
     C                   END
      *
      *
      ** Validate Payment Settlement Method.
     C     SPSETM        IFNE      *BLANKS
      *
     C* ENQUIRY NOT ALLOWED FOR SETTLEMENT INSTRUCTIONS
     C*
     C                   MOVEL     SPSETM        @QMARK
     C     @QMARK        IFEQ      '?'
 
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0048'     Msgid1
     C                   MOVE      'Y'           Mistake2
     C                   END
     C*
     C     SPSETM        IFLT      '00'
     C     SPSETM        ORGT      '08'
      *
     C     SPSETM        ANDNE     '12'
     C     SPSETM        ANDNE     '14'
 
     C     Mistake2      IFNE      'Y'
     C*
     C* If enquiry error already, don't write validation error
     C*
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0044'     Msgid1
     C                   MOVE      'Y'           Mistake2
      *
     C                   END
     C                   END
      *
     C     Mistake2      IFEQ      'N'
      *
     C     SPSETM        IFEQ      '04'
     C     SPSETM        OREQ      '14'
      *
     C     IND89         IFEQ      '0'
     C     BGRTBN        OREQ      'N'
 
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0045'     Msgid1
     C                   MOVE      'Y'           Mistake2
     C                   END
     C                   END
     C                   END
     C*
     C/COPY WNCPYSRC,DL1602IVS4
     C*
      *
     C     Mistake2      IFEQ      'N'
     C     IND88         ANDEQ     '0'
     C     SPSETM        ANDEQ     '14'
 
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0046'     Msgid1
     C                   MOVE      'Y'           Mistake2
     C                   END
      *
     C     Mistake2      IFEQ      'N'
     C     SUCUCY        ANDNE     BLUSCY
     C     SPSETM        ANDEQ     '07'
 
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0047'     Msgid1
     C                   MOVE      'Y'           Mistake2
     C                   END
      *
     C                   END
     C*
     C/COPY WNCPYSRC,DL1602IC23
     C*
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    SRSETM
     C                   PARM                    SPSETM
     C                   PARM                    IND88
     C                   PARM                    IND89
     C                   PARM                    SUCUCY
     C                   PARM                    BLUSCY
     C                   PARM                    BGRTBN
 
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
