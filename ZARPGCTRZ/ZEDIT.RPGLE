     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Insert decimal pt. and 0's for numeric')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZEDIT  - Midas standard subprograms.                         *
      *                                                               *
      *  Function:  This module edits a numeric field by inserting a  *
      *             decimal point into the input field and blanking   *
      *             out the leading zeroes.                           *
      *                                                               *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZEDIT         *
      *  subroutine.  The subroutine consists of one /COPY members.   *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
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
      *  Last Amend No. CAP002  *CREATE    Date 22Jan98               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP002 - Conversion of SE inputs into modular structure to   *
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
      *
      ** +--- The converted ZEDITZ1 starts here ---------------------------+
 
     D ZA1             S              1    DIM(16)                              ZALIGN/ZEDIT ARRAY
     D ZA2             S              1    DIM(16)                              ZALIGN/ZEDIT ARRAY
 
      ** +--- The converted ZEDITZ1 ends here -----------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
 
      ** Numeric Input (also the output)
     D   ZFIELD        S             16A
 
      ** Number of decimal position
     D   ZADEC         S              1P 0
 
      ** Working Variables
 
     D ZADEC2          S              2P 0
 
      ** Array Index
     D   IdZ1          S              2P 0
     D   IdZ2          S              2P 0
 
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
     C                   EXSR      ZEDIT
      *
     C                   RETURN
 
     C/EJECT
 
      ** +--- The converted ZEDITZ2 starts here ---------------------------+
 
      *****************************************************************
     C     ZEDIT         BEGSR                                                  ***  ZEDIT  ***
      *
      **  Set-up Work fields
      *
     C                   MOVEA     ' '           ZA1
     C                   MOVEA     ' '           ZA2
 
     C                   Z-ADD     16            IdZ1
     C                   Z-ADD     16            IdZ2
 
     C     16            SUB       ZADEC         ZADEC2
 
     C                   MOVEA     ZFIELD        ZA1
      *
      ** Check if there are any decimal places.
      *
     C     ZADEC         COMP      0                                      91
     C   91              GOTO      ZT20
 
     C     ZT10          TAG                                                    ** ZT10 TAG ***
      *
      **  Set-up Decimals
      *
     C                   MOVE      ZA1(IdZ1)     ZA2(IdZ2)
     C     IdZ1          SUB       1             IdZ1
     C     IdZ2          SUB       1             IdZ2
 
     C     IdZ2          COMP      0                                      90
     C   90              GOTO      ZT30
      *
      ** Check if end of decimals
      *
     C     IdZ2          COMP      ZADEC2                             90
     C   90              GOTO      ZT10
      *
      ** Put in decimal place
      *
     C                   MOVE      '.'           ZA2(IdZ2)
     C     IdZ2          SUB       1             IdZ2
 
     C     ZT20          TAG                                                    ** ZT20 TAG ***
      *
      ** Set-up integers
      *
     C                   MOVE      ZA1(IdZ1)     ZA2(IdZ2)
     C     IdZ1          SUB       1             IdZ1
     C     IdZ2          SUB       1             IdZ2
 
     C     IdZ2          COMP      0                                  90
     C   90              GOTO      ZT20
      *
      ** Put in leading blanks
      *
     C     ZT30          TAG
 
     C                   Z-ADD     1             IdZ2
 
     C     ZT40          TAG
 
     C     ZA2(IdZ2)     COMP      '0'                                9090
     C   90ZA2(IdZ2)     COMP      ' '                                9090
 
     C   90              GOTO      ZT50
 
     C                   MOVE      ' '           ZA2(IdZ2)
     C     IdZ2          ADD       1             IdZ2
 
     C     IdZ2          COMP      16                                   90
     C   90              GOTO      ZT40
      *
      ** If no integers, put in leading zero
      *
     C     ZT50          TAG                                                    ** ZT50 TAG ***
 
     C                   Z-ADD     ZADEC2        IdZ2
     C  N91IdZ2          SUB       1             IdZ2
     C     ZA2(IdZ2)     COMP      ' '                                    90
     C   90              MOVE      '0'           ZA2(IdZ2)
      *
      ** Set-up Output Field
      *
     C     ZT60          TAG
      *
     C                   MOVEA     ZA2           ZFIELD
     C**
     CSR   ZEND          ENDSR                                                  ** ZEND **    *
      *****************************************************************
 
      ** +--- The converted ZEDITZ1 ends here -----------------------------+
 
 
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
 
      ** Input Fields
 
      ** Numeric Input (also the output)
     C                   PARM                    ZFIELD
      ** Number of decimal position
     C                   PARM                    ZADEC
 
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
(c) Misys International Banking Systems Ltd. 2001
