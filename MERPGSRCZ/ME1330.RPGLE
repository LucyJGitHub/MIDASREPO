     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas ME Map a translated value')
      **********************************************************************
      *                                                                    *
      *  Midas - Message management Module                                 *
      *                                                                    *
      *  ME1330 - Map a translated value                                   *
      *                                                                    *
      *  Function:  This program is used to format and map a               *
      *  translated value according to the types allowed (nostro           *
      *  account, retail account, general ledger account, customer         *
      *  number). If there s a discrepancy between the value               *
      *  translated and the type allowed (e.g Customer Number and          *
      *  type allowed is Account) then the default translated value        *
      *  will be mapped, no validity checks are performed at this          *
      *  stage.                                                            *
      *                                                                    *
      *  (c) Finastra International Limited 2001                      *
      *                                                                    *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG25808           Date 01Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 16Nov99               *
      *                                    Date DDMmmYY               *
      * Midas DBA 3.00 ----------------------------------------------------*
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG25808 - General ledger format incorrectly converted       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages      *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      * ID F  C  H  L    FUNCTION OF INDICATORS                            *
      *                                                                    *
      * 90 - General error indicator                                       *
      **********************************************************************
      * SUBROUTINE INDEX                                                   *
      *                                                                    *
      * *INZSR (for first call)                                            *
      * Format -  Format the translated value                              *
      * FmtCust -  Format the customer number                              *
      * FmtAcc -  Format the account number                                *
      * Nothing -                                                          *
      * FNostr - Format if possible as a full nostro                       *
      * Nostro - Format if possible as a nostro                            *
      * Retail - Format if possible as a retail                            *
      * GLedger - Format if possible as a general ledger                   *
      **********************************************************************
 
      ** Accounts master
     FACCNT     IF   E           K DISK
 
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      * Data Structures used by Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Nostro details
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D***GENLEDGLEN      C                   CONST(18)                                      BUG25808
     D GENLEDGLEN      C                   CONST(24)                                        BUG25808
     D CUSTNUMLEN      C                   CONST(6)
     D NBTYPE          C                   CONST(10)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** WORKING VARIABLES
      ** -----------------
      *
      ** Type selected
     D TypeSel         S              1
 
      ** DATA STRUCTURES
      ** ---------------
      *
      ** Break down MIDAS equivalent
     D Acno_a          DS
     D   ACNO
      *
      ** Break down MIDAS equivalent
     D TrCode          DS
     D   TrCnum                       6
     D***TrCnum_n                     6  0 Overlay(TrCnum)                                    CSD027
     D   TrCnum_n                     6    Overlay(TrCnum)                                    CSD027
     D   TrCycd                       3
     D***TrAcod*                      4                                                       CGL029
     D***TrAcod_n                     4  0 Overlay(TrAcod)                                    CGL029
     D   TrAcod                      10                                                       CGL029
     D   TrAcod_n                    10  0 Overlay(TrAcod)                                    CGL029
     D   TrAcsq                       2
     D   TrAcsq_n                     2  0 Overlay(TrAcsq)
     D   TrBrcd                       3
      *
      ** General Ledger Type
     D GLType          DS
     D   GLBrcd                       3
     D   GLCnum                       6
     D***GLAcod*                      4                                                       CGL029
     D   GLAcod                      10                                                       CGL029
     D   GLCycd                       3
     D   GLAcsq                       2
      *
      ** Special Case
     D SpecialC        DS
      ** Name of the special case to be tested
     D   SpName                      10
     D   SpType                       2
     D   SpFill                     244
      ** Put here the new parameters you want to handle
      ** the special case
     D   SpFmt1                            Overlay(SpFill) Like(SpFill)
 
      ** INDEXS
      ** ------
     D TrCodeLen       S              3  0
     D q               S              2  0
     D t               S                   Like(q)
 
      ** ARRAYS
      ** ------
 
      ** Array of types allowed
      ** C customer number
      ** R retail account
      ** N nostro account
      ** G general ledger account
      ** and so on
     D TypeAllow       S                   Dim(NBTYPE)  Like(TypeSel)
 
      ** Array of subroutines stack
     D SrStack         S             15    Dim(30)
 
      ** FLAGS
      ** -----
 
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
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'Beg'         SrStack(q)
 
      ** Initialise
     C                   Movel     *BLANKS       Result
     C                   Movel     *BLANKS       TypeSel
     C                   Movel     *BLANKS       RetCodeIn
 
      ** Format translated variable
     C     Trcode        Ifne      *BLANK
     C                   Exsr      Format
     C     Result        Ifeq      *BLANK
     C                   Movel     '*WARNING'    RetCodeIn
     C                   Movel     TrCode        Result
     C                   Endif
 
      ** Put prefix variable if necessary
     C     Prefix        Ifne      *BLANK
     C     Prefix        Cat       Result:0      Result
     C                   Endif
 
     C                   Endif
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
      ** Return
     C                   Return
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * Format -  Format the translated value                              *
      **********************************************************************
     C     Format        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'Format'      SrStack(q)
 
      ** Determine the length of the translated value
     C     ' '           Checkr    TrCode        TrCodeLen
 
     C                   Z-add     1             t
     C     TypeAllow(t)  Downe     *BLANKS
 
     C     TrCodeLen     Caseq     CUSTNUMLEN    FmtCust
     C     TrCodeLen     Caseq     GENLEDGLEN    FmtAcc
     C                   Cas                     Nothing
     C                   Endcs
 
      ** Leave if translated value has been formated
     C     Result        Ifne      *BLANK
     C                   Movel     TypeAllow(t)  TypeSel
     C                   Leave
     C                   Endif
 
     C                   Add       1             t
 
     C     t             Ifgt      NBTYPE
     C                   Leave
     C                   Endif
 
     C                   Enddo
 
      **  Unwind subroutine stack name
     C     End_Format    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * FmtCust -  Format the customer number                              *
      **********************************************************************
     C     FmtCust       Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'FmtCust'     SrStack(q)
 
     C                   Movel     Trcode        Result
 
      **  Unwind subroutine stack name
     C     End_FmtC      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * FmtAcc -  Format the account number                                *
      **********************************************************************
     C     FmtAcc        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'FmtAccount'  SrStack(q)
 
     C     TypeAllow(t)  Caseq     'N'           Nostro
     C     TypeAllow(t)  Caseq     'F'           FNostr
     C     TypeAllow(t)  Caseq     'R'           Retail
     C     TypeAllow(t)  Caseq     'G'           GLedger
     C                   Cas                     Nothing
     C                   Endcs
 
      **  Unwind subroutine stack name
     C     End_FmtA      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * Nothing -                                                          *
      **********************************************************************
     C     Nothing       Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'Nothing'     SrStack(q)
 
      **  Unwind subroutine stack name
     C     End_Nothg     Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * FNostr - Format if possible as a full nostro                       *
      **********************************************************************
     C     FNostr        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'FNostr'      SrStack(q)
 
     C                   Callb     'AONOSTR0'                           90
     C                   Parm                    RtnCod            7
     C                   Parm      '*KEY'        Option            7
     C                   Parm                    TrCnum
     C                   Parm                    TrCycd
     C                   Parm                    TrAcod
     C                   Parm                    TrAcsq
     C                   Parm      *BLANK        NostNum           2
     C                   Parm                    TrBrcd
     C                   Parm      *BLANK        CustShNa         10
     C                   Parm      *BLANK        Pnoi              1
     C     SDNOST        Parm      *BLANK        DSFDY
 
     C     *IN90         Ifne      '0'
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'ME1330   '   DBPGM
     C                   Movel     'AONOSTR0'    DBFILE
     C                   Z-add     01            DBASE
     C                   Movel     '*CALL'       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
     C     RtnCod        Ifeq      *BLANK
     C     Result        Cat       A7CYCD:0      Result
     C     Result        Cat       A7NONB:0      Result
     C                   Endif
 
      **  Unwind subroutine stack name
     C     End_FNst      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * Nostro - Format if possible as a nostro                            *
      **********************************************************************
     C     Nostro        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'Nostro'      SrStack(q)
 
     C                   Callb     'AONOSTR0'                           90
     C                   Parm                    RtnCod            7
     C                   Parm      '*KEY'        Option            7
     C                   Parm                    TrCnum
     C                   Parm                    TrCycd
     C                   Parm                    TrAcod
     C                   Parm                    TrAcsq
     C                   Parm      *BLANK        NostNum           2
     C                   Parm                    TrBrcd
     C                   Parm      *BLANK        CustShNa         10
     C                   Parm      *BLANK        Pnoi              1
     C     SDNOST        Parm      *BLANK        DSFDY
 
     C     *IN90         Ifne      '0'
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'ME1330   '   DBPGM
     C                   Movel     'AONOSTR0'    DBFILE
     C                   Z-add     01            DBASE
     C                   Movel     '*CALL'       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
     C     RtnCod        Ifeq      *BLANK
     C                   Movel     A7NONB        Result
     C                   Endif
 
      **  Unwind subroutine stack name
     C     End_Nost      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * Retail - Format if possible as a retail                            *
      **********************************************************************
     C     Retail        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'Retail'      SrStack(q)
 
     C     KyRtac        Klist
     C                   Kfld                    TrCnum_n
     C                   Kfld                    TrCycd
     C                   Kfld                    TrAcod_n
     C                   Kfld                    TrAcsq_n
     C                   Kfld                    TrBrcd
 
     C     KyRtac        Chain     ACCNT                              90
     C     *IN90         Ifeq      '0'
     C     RECI          andeq     'D'
     C     ATYP          andeq     'R'
     C                   Movel     Acno_a        Result
     C                   Endif
 
      **  Unwind subroutine stack name
     C     End_Retl      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * GLedger - Format if possible as a general ledger                   *
      **********************************************************************
     C     GLedger       Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'GLedger'     SrStack(q)
 
     C                   Movel     TrBrcd        GLBrcd
     C                   Movel     TrCnum        GLCnum
     C                   Movel     TrCycd        GLCycd
     C                   Movel     TrAcod        GLAcod
     C                   Movel     TrAcsq        GLAcsq
 
     C                   Movel     GLType        Result
 
      **  Unwind subroutine stack name
     C     End_GLdg      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      * *INZSR - Program Initialisation routine                            *
      *                                                                    *
      * Called by: Main processing                                         *
      *                                                                    *
      * Calls: None                                                        *
      *                                                                    *
      **********************************************************************
 
     C     *INZSR        Begsr
 
     C     *Entry        Plist
      ** Input : Translated value
     C**********         Parm                    TrCode           18                          CGL029
     C                   Parm                    TrCode                                       CGL029
      ** Input : (optional) variable to put before the formated value
     C                   Parm                    Prefix           20
      ** Input : Types allowed
     C                   Parm                    TypeAllow
      ** Input : Special case (to allow further variables to be passed
      ** in the future)
     C                   Parm                    SpecialC
      ** Output : Formated value
     C                   Parm                    Result          256
      ** Output ; Return code
      ** *ERROR critical error
      ** *WARNING warning
     C                   Parm                    RetCodeIn
      ** Output ; Type selected
     C                   Parm                    TypeSel
 
      *  Program, module and procedure names for database error processing.
      *  The following /COPY sets these values, and also defines LDA as
      *  an external data area
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
