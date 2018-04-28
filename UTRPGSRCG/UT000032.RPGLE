      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Extract Validation List Entries')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  UT000032 - Midas UT Extract Validation List Entries          *
      *                                                               *
      *  Function:  This program extracts all validation list         *
      *             entries and saves it to an outout file            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. BUG27989*CREATE    Date 08Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27989 - HATS should run with/without LDAP                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrClrEntry - Clear output buffer data (DS Entry)             *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Validation List Entries Retrieval File
     FUTVLLEL0  UF A E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+
 
      * Prototype for calling API "QsyFindFirstValidationLstEntry()"
      *  (Find First Validation List Entry)
     D Get1stEntry     PR            10I 0 EXTPROC('QsyFindFirstValidationLst-
     D                                     Entry')
     D PointerE1A                      *   VALUE
     D PointerE1B                      *   VALUE
 
      * Prototype for calling API "QsyFindNextValidationLstEntry()"
      *  (Find Next Validation List Entry)
     D GetNxtEntry     PR            10I 0 EXTPROC('QsyFindNextValidationLst-
     D                                     Entry')
     D PointerE1A                      *   VALUE
     D PointerE1B                      *   VALUE
     D PointerE1C                      *   VALUE
 
      *-----------------------------------
      *  Structure of input buffer for API
      *  "QsyFindNextValidationLstEntry()"
      *----------------
 
      * Qsy_Entry_ID_Info_T structure
     D CurEntry        DS                  ALIGN
      * 1- Entry ID information structure
     DCurEn_ID_Len                   10I 0
     DCurEn_ID_CCSID                 10U 0
     DCurEn_ID                      100A
 
      *-----------------------------------
      *  Structure of output buffer for APIs
      *  "QsyFindFirstValidationLstEntry()"
      *  "QsyFindNextValidationLstEntry()"
      *----------------
      * Qsy_Rtn_Vld_Lst_Ent_T structure
 
     D Entry           DS                  ALIGN
      * 1- Entry ID information structure
     DEntry_ID_Len                   10I 0
     DEntry_ID_CCSID                 10U 0
     DEntry_ID                      100A
 
      * 2- Data to be encrypted information structure
     DEncr_Data_Len                  10I 0
     DEncr_Data_CCSID                10U 0
     DEncr_Data                     600A
 
      * 3- Entry data information structure
     DEntry_Data_Len                 10I 0
     DEntry_Data_CCSI                10U 0
     DEntry_Data                   1000A
 
      * 4- Ignored field.
     Dignored                         4A
 
      * 5- Pointer currently set to NULL
     DEntry_More_Info  S               *
 
      ** +--------------------------------------+
      ** ¦ End - Prototypes                     ¦
      ** ¦ ================                     ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Find            C                   CONST('F')
     D VLDL            S             20A
     D RC              S              2S 0
     D Ix              S              4S 0
 
      ** UT000033 Parameters
     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D PuserName       S            256A
     D PPass1          S            256A
     D PPass2          S            256A
     D PDescr          S             50A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MAIN - Processing
      *****************************************************************
      *
     C                   EVAL      VLDL = PValidList + PLibrary
     C                   EVAL      Ix = 0
      *
     C                   EXSR      ClrEntry
      *
      ** Get first entry in validation list object
      *
     C                   EVAL      RC=Get1stEntry(%ADDR(VLDL):%ADDR(Entry))
      *
     C                   DOW       RC=0
      *
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      CurEn_ID_Len  =Entry_ID_Len
     C                   EVAL      CurEn_ID_CCSID=Entry_ID_CCSID
     C                   EVAL      CurEn_ID      =Entry_ID
      *
      ** Retrieve Description
      *
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Find          PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      CurEn_ID      PUserName
     C                   PARM      *BLANKS       PPass1
     C                   PARM      *BLANKS       PPass2
     C                   PARM                    PDescr
      *
     C                   IF        PReturnCode = *BLANKS
     C                   EVAL      VLUSER = CurEn_Id
     C                   EVAL      VLDESC = PDescr
     C                   WRITE     UTVLLED0
     C                   ENDIF
      *
     C                   EXSR      ClrEntry
      *
      ** Get succeeding entries in validation list object
      *
     C                   EVAL      RC=GetNxtEntry(%ADDR(VLDL):%ADDR(CurEntry):
     C                              %ADDR(Entry))
      *
     C                   ENDDO
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrClrEntry - Clear output buffer data (DS Entry)             *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     ClrEntry      BEGSR
      *
     C                   EVAL      Entry_ID_Len   =0
     C                   EVAL      Entry_ID_CCSID =0
     C                   EVAL      Entry_ID       = ' '
     C                   EVAL      Encr_Data_Len  =0
     C                   EVAL      Encr_Data_CCSID=0
     C                   EVAL      Encr_Data      = ' '
     C                   EVAL      Entry_Data_Len =0
     C                   EVAL      Entry_Data_CCSI=0
     C                   EVAL      Entry_Data     = ' '
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on Program Activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2010
