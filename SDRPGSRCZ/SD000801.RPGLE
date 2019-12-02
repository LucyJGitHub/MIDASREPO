     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Automated closure of Retail A/C')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD000801 - Automatic Deletion of Retail A/C                  *
      *                                                               *
      *  Function: This module is used to retrieve Retail Accounts    *
      *            from the Midas database and then flag them for     *
      *            deletion                                           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD027217           Date 29May14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD023  *CREATE    Date 18Nov04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027217 - Not possible to authorize customer closure        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSD023 - Automatic Customer Account Closure                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** error arrays, including the named constant giving the size of
      ** the arrays.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)

      ** Array of Fields in error.
     D FldNameArr      S             10A   DIM(ArrayMax)

      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)

      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)

      ** Array of Fields with warnings.
     D WFldNamArr      S             10A   DIM(ArrayMax)

      ** Array of warning message IDs
     D WMsgIDArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)

      ** Array of warning message data.
     D WMsgDtaArr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)

      ** Variables
     D Parm            S           1000
     D Buffer          S           6000
     D MsgArrOUT       S           9999
     D UPDATEYN        S              1
     D @TimeStamp      S             26
     D FwdBck          S              1
     D MIDAcc          S             24

      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Standard parameters for called programs
     D DSBuffer        DS          6000
     D  TRANS1                 1    500
     D  TRANS2               501   1000
     D  TRANS3              1001   1500
     D  TRANS4              1501   2000
     D  TRANS5              2001   2500
     D  ExtData             2501   3000

     D AccnInMast    E DS                  EXTNAME(GLAMADPD)

      **********************************************************************
      /SPACE 5
      **********************************************************************
      * Start of main processing
      **********************************************************************

      * Call the GLAMADR API for input

     C                   EXSR      CallRead

      * Extract data for update

     C                   Z-ADD     1             Bfp               4 0

     C     AMMDLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       AMMDLn        Bfp
     C     AMDILn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       AMDILn        Bfp
     C     AMCILn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       AMCILn        Bfp
     C     AMCOLn        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       AMCOLn        Bfp
     C     AMODLn        SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       AMODLn        Bfp
      **  Restore Timestamp field from the record
     C     26            SUBST     BUFFER:Bfp    @TimeStamp
     C                   ADD       26            Bfp

      * Here you must set the action code for deletion
     C                   MOVEL     TRANS1        AccnInMast
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     AccnInMast    TRANS1

      * Call the SD000804 API for output

     C                   EXSR      CallDelete

     C                   SETON                                        LR
     C                   RETURN
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Call the GLAMADR API
      ****************************************************************
     C     CallRead      BEGSR

     C                   CALLB     'GLAMADR'
     C                   PARM      *blanks       FwdBck
     C                   PARM                    MIDAcc
     C                   PARM                    Buffer
     C                   PARM                    Buffer2        3999                        MD027217
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM      *blanks       ErrorC            1

      * A problem with the account ref occurred, abort process

     C                   MOVEA(P)  FldNameArr    Parm

     C     ErrorC        IFEQ      '0'
     C     Parm          ORNE      *blanks
     C                   move      *on           ErrorCode
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Call the SD000804 API
      ****************************************************************
     C     CallDelete    BEGSR

     C                   CALLB     'GL001505'
      * Common header information (DS) from source system
     C                   PARM      *blanks       HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    Trans3
     C                   PARM                    Trans4
     C                   PARM                    Trans5
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM      'Y'           UpdateYN
     C                   PARM                    Buffer
     C                   PARM      *blanks       ErrorC
     C                   PARM                    @TimeStamp

      * A problem with the account ref occurred, abort process

     C                   MOVEA(P)  FldNameArr    Parm

     C     ErrorC        IFEQ      '0'
     C     Parm          ORNE      *blanks
     C                   move      *on           ErrorCode
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Initialise program *INZSR
      ****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    MIDAcc
     C                   PARM                    ErrorCode         1

      **--------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------

     C                   EXSR      AMADFmts

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      *  Get Record Lengths of Transaction Data Blocks               *
      ****************************************************************
     C     GETRCDLN      BEGSR

     C                   CALLB     'UTGETRCDLN'

      ** Return code
     C                   PARM                    ReturnCode       10
      ** Record length
     C                   PARM      *ZERO         RecordLen         5 0

      ** File name
     C                   PARM                    FileName         10
      ** File library
     C                   PARM      '*LIBL     '  FileLib          10

      ** If file not found (or any other error) shut down the program
     C     ReturnCode    Ifne      *Blanks
     C                   EXSR      *pssr
     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** GL Accounts maintenance : Master, Debit interests, Credit interests
      **               Commissions & Overdraft charges and Other details
      *****************************************************************
     C     AMADFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'GLAMADPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMMDLn            4 0

     C                   MOVEL     'GLAMDIPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMDILn            4 0

     C                   MOVEL     'GLAMCIPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMCILn            4 0

     C                   MOVEL     'GLAMCOPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMCOLn            4 0

     C                   MOVEL     'GLAMODPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMODLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2004
