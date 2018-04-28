     H*DEBUG****                                                                             BUG6139
     H DEBUG ALWNULL(*INPUTONLY)                                                             BUG6139
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Retrieve Eligible Customers')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000020 - Retrieve Extension File Details and               *
      *             Eligible Customers                                *
      *                                                               *
      *  Function:  This program will access LF/LEGRCLL0 for the      *
      *             Eligible Customers, using the Customer Group      *
      *             accepted as an input parameter.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG6139            Date 14Feb05               *
      *  Prev Amend No. BUG3819            Date 27Jul04               *
      *                 CLE039  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG6139 - Allow files with null-capable fields to be read    *
      *            without causing data mapping errors.               *
      *  BUG3819 - Ignore null values in files. (Recompile)           *
      *  CLE039 - General LE Enhancement                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Customer Group Links by Parent Group and Customer Number
     FLEGRCLL0  IF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      **------------------------------------------------------------------------
 
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
 
      ** External data structure to hold the outgoing record format
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Array for Eligible Customers (133 x 6A = 798A)
     D EliCust         S              6A   DIM(133) INZ(*BLANKS)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRun            S              1A   INZ(*BLANKS)
     D I               S              3S 0 INZ(*ZERO)
 
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
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd             7
     C                   PARM                    PCustGrp         20 0
     C                   PARM                    DSSDY
 
      ** Initialise fields
 
     C                   EVAL      PRtcd = *BLANKS
     C                   EVAL      DSSDY = *BLANKS
     C                   EVAL      I = *ZERO
 
      ** Get all Eligible Customers using partial key
 
     C     PCustGrp      SETLL     LEGRCLL0
     C     PCustGrp      READE     LEGRCLL0                               82
 
     C                   DOW       *IN82 = *OFF
     C                   EVAL      I = I + 1
     C     6             SUBST     CLCUSTCODE:5  EliCust(I)
     C     PCustGrp      READE     LEGRCLL0                               82
     C                   ENDDO
 
     C                   MOVEA     EliCust       DSSDY
 
      ** End program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR - Program exception error routine                      *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      PRtcd = '*ERROR'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
