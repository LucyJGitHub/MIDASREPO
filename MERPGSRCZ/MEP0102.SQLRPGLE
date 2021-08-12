     *************** Beginning of data ********************************************************
     H DEBUG
      *****************************************************************
/*STD *  RPGSQLMOD                                                   *
/*EXI *  TEXT('Midas ME  Program to access record from in-house')    *
      *****************************************************************
      *                                                               *
      *  MEP0102 - Midas Program to access record from in-house       *
      *            Holiday file                                       *
      *                                                               *
      *  Function: This program checks todays date against the        *
      *            holiday file to see if banks is open.              *
      *            This program is used to stop STP processing        *
      *            starting on bank holiday.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 06Oct2011             *
      *                 HVB019 *CREATE     Date 02Dec2011             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP Enhancements to Midas Plus level.     *
      *  HVB019   - DISABLE STP on Bank holiday                       *
      *                                                               *
      *****************************************************************
      *
      *?External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      *? Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D W_HOLIDAY     E DS                  ExtName(BVRHOLPF) prefix(A_)
      *
      *?Work Variables
     D W_Today         S                   Like(BJRDNB)
     D DbFile          S             10
     D DBase           S              3  0
     D DBkey           S             29
      *
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
      ** To release file after the program ended.
     C/EXEC SQL
     C+ set option CLOSQLCSR = *ENDMOD
     C/END-EXEC
      *
      *
     C/EXEC SQL
     C+ set option commit=*none,
     C+            datfmt=*iso
     C/END-EXEC
      *
      ** Select record from holiday file
      *
     C/EXEC SQL
     c+ select  *
     c+ into :W_HOLIDAY
     c+ from BVRHOLPF
     c+   where C7PSNB = :W_Today
     c/END-EXEC
      *
      *  Check for successful completion
     C                   If        (SQLCOD <> 0)
     C                   Move      '*OPEN  '     PRTN
     C                   If        (%SUBST(SQLSTATE:1:2) <> '02')
     C                   ExSR      *PSSR
     C                   EndIf
     C                   EndIf
      *
     C     SQLCOD        Ifeq      0
     C                   Move      '*CLOSED'     PRTN
     C                   EndIf
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *  INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      *?Entry parameters:
     C     *Entry        Plist
      *
      *  Return Code
     C                   Parm                    PRTN              7

      *?Initialise program name

      * Get current Midas run date from SDBANKPD
     C*******************CallB     'AOBANKR0'                                               EFix0022
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSSDY
      *
      * Database error
     C                   If        @RTCD <> *Blanks
     C                   Eval      DbFile = 'SDBANKPD'
     C                   Eval      DBase = 1
     C                   Eval      DBkey = @Optn
     C                   Exsr      *PSSR
     C                   Endif

      * Save todays date
     C                   Eval      W_Today = BJRDNB
      *
     C                   Endsr
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   Move      '*ERROR'      PRTN
      *
     C     RunBefore     IFEQ      *BLANKS

     C                   MOVE      'Y'           RunBefore         1

     C                   DUMP
     C                   ENDIF

     C                   SETON                                        LRU7U8
     C                   RETURN
      *
     C                   ENDSR
      *
