     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Short position warning')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESHPOSWN - Short Position Warning                           *
      *                                                               *
      *  Function:  This is to test if the position is less than the  *
      *             nominal of the Trade Purchased.                   *
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
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSE013  *CREATE    Date 28May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE013 - Short Position Warning.                             *
      *                                                               *
      *****************************************************************
     FCDEPH     IF   E           K DISK
     F                                     RENAME(CDEPPDF:CDEPPDFX)
     F** Customer depot position & hist
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Cumutative Position
     D     CumulPosit  S                   LIKE(NOML)
     D                                     INZ(0)
 
      ** Starting Position
     D     StartPosit  S             15  0
 
 
     D*DELF*****       S              6S 0                                                    CSD027
     D DELF            S              6A                                                      CSD027
 
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
      **  Initilalization
      *
     C                   Z-ADD     NOML          StartPosit
     C                   MOVE      CustNum       KeyCustNum
 
     C                   Z-ADD     *ZERO         CumulPosit
      *
      **  Position on File
      *
     C     KCDEPH        SETLL     CDEPH
     C     KCDEPH        READE     CDEPH                                  99
      *
      ** Do While same Key
     C     *IN99         DOWEQ     '0'
      *
     C     RECI          IFEQ      'D'
      *
      ***  Cumulate the position of the depot
      *
     C     BVTVDV        IFEQ      'T'
     C                   ADD       CDNT          CumulPosit
     C                   ADD       SNPT          CumulPosit
     C                   ADD       CDST          CumulPosit
     C                   ELSE
     C                   ADD       CDNV          CumulPosit
     C                   ADD       CNPV          CumulPosit
     C                   ADD       CNSV          CumulPosit
     C                   END
      *
     C                   END
      *
     C     KCDEPH        READE     CDEPH                                  99
      *
     C                   END
      *
      ** Compare Cumulate Position with Starting Position
      *
     C     CumulPosit    IFLT      StartPosit
     C                   MOVE      '1'           ShortFlag
     C                   ELSE
     C                   MOVE      '0'           ShortFlag
     C                   ENDIF
      *
      ** Termination
     C                   RETURN
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
      *
      ** INPUTS
      *
      ** Return Code
     C                   PARM                    ReturnCode
      ** Branch Code (3A)
      ** Customer number (6A)
      ** Security Shortname (10A)
      ** Nominal Amount (11P 0)
      ** Deliver From (6 0)
      ** Trade/Value Date Valuation (1A)
     C                   PARM                    DDBRCD            3
     C                   PARM                    CustNum           6
     C                   PARM                    DDSESN           10
     C                   PARM                    NOML             11 0
     C                   PARM                    DELF
     C                   PARM                    BVTVDV            1
      *
      ** OUTPUT
      *
     C                   PARM                    ShortFlag         1
      *
      ***  KLIST for CDEPH
      *
     C     KCDEPH        KLIST
     C                   KFLD                    DDBRCD
     C**********         KFLD                    KeyCustNum        6 0                        CSD027
     C                   KFLD                    KeyCustNum        6                          CSD027
     C                   KFLD                    DDSESN
     C                   KFLD                    DELF
      *
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     InzEnd        ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
