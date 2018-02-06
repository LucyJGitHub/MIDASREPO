     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Update OLPOS file')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects Module                                *
      *                                                               *
      *     AOOPLSU0 - Update Olpos file                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD026169           Date 09Apr14               *
      *                 MD025679B          Date 26Mar14               *
      *                 MD025679A          Date 21Mar14               *
      *                 MD025679           Date 13Mar14               *
      *                 AR868380           Date 10Jun13               *
      *                 AR651185           Date 23Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 213720             Date 25Mar03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 145949             Date 23Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 01May98               *
      *                 041693             DATE 05JAN93               *
      *                 045014             DATE 01DEC92               *
      *                 031876             DATE 03NOV92               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026169 - GO_ONL_OLP background job is processing           *
      *             full receiver chain                               *
      *  MD025679B - API - PRONO Locking Issue. Renamed GLOLPSTD      *
      *  MD025679A - Added copyright to program                       *
      *  MD025679 - Rewrite. Optimized code was move to AOOLPSU1.     *
      *           - API - OLPOSOA Locking Issue.                      *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  AR651185 - Midas is not responding. Applied fix of 249627.   *
      *             Amend fix 213720 to delay the job for 1 second    *
      *             instead of 10 (Child: AR651186)                   *
      *  213720 - Record lock occured.  Delay job if record is locked *
      *           by another user.  Bypass if record cannot be        *
      *           allocated.                                          *
      *  145949 - Spot position is being updated if value date        *
      *           is after last date held in the position array.      *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
      *  041693 - Delivered as part of fix.                           *
      *                                                               *
      *  045014 - Add call to AOCNTLR0 for access control             *
      *                                                               *
      *  031876 - New program to update OLPOS file for shadow         *
      *           post.                                               *
      *                                                               *
      *****************************************************************
     FGLOLPSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *****************************************************************
      **
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      *
      ** Entry parameter
      *
     D W0KEY#          S              8A
     D W0VDAT          S              5P 0
     D W0AMT           S             15P 0
     D W0IO            S              1A
      /EJECT
      *****************************************************************
      * MAIN - Main body                                              *
      *****************************************************************
      *
     C                   MOVE      W0KEY#        OLKEY
     C                   Z-ADD     W0VDAT        OLVDAT
     C                   Z-ADD     W0AMT         OLAMT
     C                   MOVE      W0IO          OLIO
      *
     C                   WRITE(E)  GLOLPST0
      *
     C                   IF        %ERROR
     C                   MOVEL     '*ERROR '     W0RTN
     C                   EVAL      DBFILE      = 'GLOLPSL0'
     C                   MOVEL(P)  OLKEY         DBKEY
     C                   EVAL      DBASE       = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      * *INZSR - Program Initialisation routine
      ************************************************************
     C     *INZSR        BEGSR
      *
      ***  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  Return Code
     C                   PARM                    W0RTN             7
      *
      ***  Olpos key
     C                   PARM                    W0KEY#
      *
      *** VDate
     C                   PARM                    W0VDAT
      *
      *** Amount
     C                   PARM                    W0AMT
      *
      *** Incoming/Outgoing
     C                   PARM                    W0IO
      *
     C                   ENDSR
     ****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Finastra International Limited 2014
