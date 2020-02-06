     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA SE edit numeric and floating character')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZSEDITF - Midas standard subprograms.                        *
      *                                                               *
      *  Function:  This module inserts a decimal point and sign      *
      *             into a numeric field and to blank out leading     *
      *             zeros (optionaly inserting commas). It can also   *
      *             insert a floating character before the leading    *
      *             digit of a field.                                 *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZSEDIT        *
      *  subroutine.  The subroutine consists of three /COPY members. *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
      *  - Other amendments includes the modification of some fields  *
      *    in the program to contain meaningful names.                *
      *  - In this particular module, the ZSEDITZ31 /COPY member was  *
      *    included in this program NOT the ZSEDITZ3 /COPY.           *
      *                                                               *
      *  The boundaries of the original /COPY members have been       *
      *  marked, to facilitated future maintenance of both the old    *
      *  members and this one.                                        *
      *                                                               *
      *  If this member has to change, the changes should ALMOST      *
      *  CERTAINLY be implemented by changing the old /COPY member,   *
      *  reconverting it using CVTRPGSRC, and copying it into this    *
      *  member, replacing the existing section and re-changing the   *
      *  EXSRs to CALLBs.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 243868             Date 22Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 238603             Date 28Aug06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *Create    Date 23Jan98               *
      *                 nnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  243868 - Amount and CR sign are truncated in Account Enquiry *
      *           Prompt. Reverse fix 238603.                         *
      *  238603 - Z2 is not initialized correctly and led field       *
      *           ZOUT21 to have a blank on the rightmost position.   *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
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
 
      **
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-Specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--- The converted ZSEDITZ1 starts here --------------------------+
     D ZS2             S              1    DIM(21)
      ** +--- The converted ZSEDITZ1 ends here ----------------------------+
 
      ** +--- The converted ZSEDITZ2 starts here --------------------------+
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
      ** +--- The converted ZSEDITZ2 ends here ----------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Initialise output
      *
     C                   MOVE      *BLANKS       ZOUT21
 
     C                   EXSR      ZSEDIT
      *
     C                   RETURN
 
     C/EJECT
 
      ** +--- The converted ZSEDITZ31 starts here -------------------------+
 
     C********************************************************************
     C**                                                                 *
     C** ZSEDIT subroutine to insert a decimal point and sign into a     *
     C** numeric field and to blank out leading zeros (optionaly         *
     C** inserting commas).                                              *
     C**                                                                 *
     C********************************************************************
     C**                                                                 *
     C** LAST AMEND NO. E20532             DATE 09DEC89                  *
     C**                                                                 *
     C**-----------------------------------------------------------------*
     C**                                                                 *
     C** E20532 - As part of this fix ZSEDIT has been improved to        *E20532
     C**          insert a floating character (whatever is passed        *E20532
     C**          in ZECHAR ) before the leading digit of a field.       *E20532
     C**                                                                 *
     C**=================================================================*
     C**                                                                 *
     C**     Input fields:   ZFLD15 15/0                                 *
     C**                     ZDECS  1/0                                  *
     C**                     ZECODE 1/  ('J', 'L' or blank)              *
     C**                     ZECHAR 1/  ('character' or blank)           *E20532
     C**                                                                 *
     C**     Arrays:         ZS1    15/1/0                               *
     C**                     ZS2    21/1/                                *
     C**                                                                 *
     C**     Output fields:  ZOUT21 21                                   *
     C**                                                                 *
     C**     Indicators   :  *IN97                                       *E20532
     C**                                                                 *E20532
     CSR   ZSEDIT        BEGSR                                                  **  ZSEDIT   *
     C*
     C* Define/Clear fields
     C*
     C                   Z-ADD     ZFLD15        ZFLD15           15 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   MOVE      ZECODE        ZECODE            1
     C                   MOVE      ZECHAR        ZECHAR            1                           E2053
     C                   MOVE      *BLANKS       ZOUT21           21
     C*
     C*       SET UP WORK FIELDS
     C*
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
     C*
     C                   Z-ADD     15            Z1                2 0
     C*******************Z-ADD     20            Z2                2 0                        238603
     C**********         Z-ADD     21            Z2                2 0                 238603 243868
     C                   Z-ADD     20            Z2                2 0                        243868
     C*
     C     15            SUB       ZDECS         ZINTS             2 0
     C*
     C* Check if numeric field is negative
     C*
     C     ZFLD15        IFLT      *ZEROS
     C                   MOVE      '-'           ZS2(21)
     C                   Z-SUB     ZFLD15        ZFLD15
     C                   END
     C*
     C                   Z-ADD     ZFLD15        WORK15
     C*
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES
     C*
     C     ZDECS         CABEQ     0             ZS10
     C*
     C*       SET UP DECIMALS
     C*
     C                   Z-ADD     *ZEROS        ZCNT              1 0
     C     ZCNT          DOUEQ     ZDECS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z2
     C                   ADD       1             ZCNT
     C                   SUB       1             Z1
     C                   END
     C*
     C*       PUT IN DECIMAL PLACE
     C*
     C                   MOVE      '.'           ZS2(Z2)
     C                   SUB       1             Z2
     C*
     C     ZS10          TAG                                                    ** ZS10 TAG **
     C*
     C*       SET UP INTEGERS
     C*
     C                   Z-ADD     *ZEROS        CNT3              1 0
     C     Z1            DOUEQ     *ZEROS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z1
     C                   SUB       1             Z2
     C*
     C* If edit code is 'J', insert a ',' before each group of three
     C* digits - not if beginning of array reached.
     C*
     C     Z2            IFGT      *ZEROS
     C     ZECODE        ANDEQ     'J'
     C                   ADD       1             CNT3
     C     CNT3          IFEQ      3
     C                   MOVE      ','           ZS2(Z2)
     C                   SUB       1             Z2
     C                   Z-ADD     *ZEROS        CNT3
     C                   END
     C                   END
     C*
     C                   END
     C*
     C*       PUT IN LEADING BLANKS and Edit Character if relevant.       E20532
     C*
     C                   Z-ADD     1             Z2                                            E2053
     C                   SETOFF                                       97                       E2053
     C*                                                                   E20532
     C     Z2            DOWLT     22                                                          E2053
     C     *IN97         ANDNE     '1'                                                         E2053
     C*                                                                   E20532
     C     ZS2(Z2)       IFEQ      '0'                                                         E2053
     C     ZS2(Z2)       OREQ      ' '
     C     ZS2(Z2)       OREQ      ','
     C                   MOVE      ' '           ZS2(Z2)
     C*                                                                   E20532
     C                   ELSE                                                                  E2053
     C*                                                                   E20532
     C                   SETON                                        97                       E2053
     C*                                                                   E20532
     C     Z2            IFGT      1                                                           E2053
     C     ZECHAR        ANDNE     ' '                                                         E2053
     C                   SUB       1             Z2                                            E2053
     C                   MOVE      ZECHAR        ZS2(Z2)                                       E2053
     C                   ELSE                                                                  E2053
     C                   SUB       1             Z2                                            E2053
     C                   END                                                                   E2053
     C                   END                                                                   E2053
     C                   ADD       1             Z2                                            E2053
     C*                                                                   E20532
     C                   END
     C*                                                                   E20532
     C                   SETOFF                                       97                       E2053
     C*
     C*       IF NO INTEGERS PUT IN LEADING ZERO
     C*
     C*
     C     Z2            IFEQ      22
     C                   SUB       2             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C*                                                                   E20532
     C     ZECHAR        IFNE      ' '                                                         E2053
     C*                                                                   E20532
     C                   SUB       1             Z2                                            E2053
     C                   MOVE      ZECHAR        ZS2(Z2)                                       E2053
     C                   END                                                                   E2053
     C*                                                                   E20532
     C                   ELSE
     C*
     C     ZS2(Z2)       IFEQ      '.'
     C                   SUB       1             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C*                                                                   E20532
     C     ZECHAR        IFNE      ' '                                                         E2053
     C                   SUB       1             Z2                                            E2053
     C                   MOVE      ZECHAR        ZS2(Z2)                                       E2053
     C                   END                                                                   E2053
     C*                                                                   E20532
     C                   END
     C                   END
     C*
     C*       SET UP OUTPUT FIELD
     C*
     C                   MOVEA     ZS2           ZOUT21
     C                   MOVE      *BLANKS       ZECHAR                                        E2053
     C*
     CSR                 ENDSR
     C*****************************************************************
 
      ** +--- The converted ZSEDITZ31 ends here ---------------------------+
 
 
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
 
      ** Field to edit
     C                   PARM                    ZFLD15
      ** Decimal places
     C                   PARM                    ZDECS
      ** Edit code ('J', 'L' or ' ')
     C                   PARM                    ZECODE
      ** Floating point character to be inserted
     C                   PARM                    ZECHAR
      ** OUTPUT ***
     C                   PARM                    ZOUT21
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
