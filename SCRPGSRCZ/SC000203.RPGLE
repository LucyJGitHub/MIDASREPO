     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Schemas/Libraries Restore Setup')             *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000203 - Select Schemas/Libraries                          *
      *                                                               *
      *  Function:  This module displays a list of schemas/libraries  *
      *             available for restoration on Input Cycle Re-Open  *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. CBF002  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  CBF002 - BF Infrastructure: Backup and Recovery              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSC000203DFCF   E             WORKSTN INFDS(TimeOut)
     F                                     SFILE(SC000203S1:DDSFRN)
     F                                     MAXDEV(*FILE)
      ** Schemas/Libraries Restore Setup
      *
     FSCBKLBL0  IF   E           K DISK
      ** Schemas/Libraries File All Records
      *
     FSCBKLBL1  UF   E           K DISK
     F                                     RENAME(SCBKLBF:SCBKLBUPD)
      ** Schemas/Libraries File Update index
      *

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK
      *
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of the
      ** arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------


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

      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Error Flag
     DWErrorFlag       DS             3
     D WErrRstFlg              1      1
     D WErrToLib               2      2
     D WErrSeqNum              3      3

      ** Display Timeout Status
     DTimeout          DS
     D TimeOutStat       *STATUS

      ** Schemas/Libraries Array
     D WSchLibArr      S             10A   DIM(200)

      ** Library Descriptions Array
     D WLibDesArr      S             20A   DIM(400)

      ** Save File Names Array
     D WSavFilArr      S             10A   DIM(200)

      ** To-Library Array
     D WToLibArr       S             10A   DIM(200)

      ** Sequence Numbers Array
     D WSeqNumArr      S             10A   DIM(200)

      ** Restore Library Array
     D WRstLibArr      S              1A   DIM(20)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WCount          S              5P 0
     D WICT            S              1A
     D WBOB            S              1A
     D WRRN            S              5P 0
     D WNum            S              2P 0
     D WSeqn           S             10P 0
     D WSavRRN         S              5P 0
      *
     D I               S              5P 0
      *
     D ExistCode       S             10A
     D Library         S             10A
     D Qsys            S             10A
     D ObjType         S             10A
     D Member          S             10A
      *
     D PBackupTyp      S             10A
     D PDevDBSave      S              4A
     D PSchemaLib      S            200A
     D PSavFilNam      S            200A
     D PToLibrary      S            200A
     D PSeqNumber      S            200A
      *
     D PgmQueue        S             10A
     D RelQueue        S              5A
     D MessageID       S              7A
     D MessageFile     S             10A
     D MessageData     S            132A
     D MessageType     S              7A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Check device for restore
      *
     C                   EVAL      *IN31 = *OFF
     C                   IF        PDevDBSave = 'TAPE'
     C                   EVAL      *IN31 = *ON
     C                   ENDIF
      *
      ** Check back-up type
      *
     C                   SELECT
     C                   WHEN      PBackupTyp = 'ICT       '
     C                   EVAL      WICT = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   WHEN      PBackupTyp = 'BOB       '
     C                   EVAL      WBOB = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   ENDSL
      *
      ** Load array from file
      *
     C                   EXSR      LOADARR
      *
      ** Build subfile
      *
     C                   EXSR      BLDSFL
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** LOADARR - Load Array From File
      *****************************************************************
     C     LOADARR       BEGSR
      *
     C     *LOVAL        SETLL     SCBKLBL0
      *
      ** Initialise array index
      *
     C                   EVAL      I = 1
     C                   READ      SCBKLBL0                               96
      *
      ** Initialise count of records written to array
      *
     C                   Z-ADD     0             WCount
      *
      ** Do while not EOF
      *
     C                   DOW       *IN96 = *OFF
      *
     C                   IF        SLSAVD = PBackUpTyp
      *
      ** Increment array counter
      *
     C                   ADD       1             WCount
      *
      ** Copy records to array
      *
     C                   EVAL      WRstLibArr(I) = 'Y'
     C                   EVAL      WSchLibArr(I) = SLLIBN
     C                   EVAL      WLibDesArr(I) = SLLIBD
      *
     C                   SELECT
     C                   WHEN      WICT = 'Y'
     C                   EVAL      WSavFilArr(I) = SLICTS
     C                   WHEN      WBOB = 'Y'
     C                   EVAL      WSavFilArr(I) = SLBOBS
     C                   ENDSL
      *
     C                   EVAL      WToLibArr(I)  = SLLIBN
      *
      ** If restore from tape,
      *
     C                   IF        *IN31 = *ON
     C                   EVAL      WSeqNumArr(I) = '*SEARCH'
     C                   ENDIF
      *
     C                   ADD       1             I
      *
     C                   ENDIF
      *
      ** Read file
      *
     C                   READ      SCBKLBL0                               96
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** BLDSFL - Build subfile
      *****************************************************************
     C     BLDSFL        BEGSR
      *
      ** Do while not EOF
      *
     C                   DOW       *INKC = *OFF
      *
      ** Load subfile
      *
     C                   EXSR      LOADSFL
      *
      ** Write footer
      *
     C                   WRITE     SC000203F0
      *
      ** Write message subfile
      *
     C                   WRITE     SC000203M0
      *
      ** If no data to display, clear subfile
      *
     C                   IF        WCount = 0
     C                   EXSR      CLRSFL
     C                   EVAL      WRRN = 1
     C                   EVAL      DDSFRN = 1
      *
      ** Write to subfile with non-display set on
      *
     C                   EVAL      *IN93 = *ON
     C                   WRITE     SC000203S1
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     SC000203S0
     C                   ELSE
      *
      ** Position cursor to first record in subfile, the display subfile
      *
     C                   EVAL      DDSFRN = 1
     C                   WRITE     SC000203S0
     C                   ENDIF
      *
     C                   READ      SC000203DF                           99LR
      *
      ** If timeout and no function key was pressed, restore all libraries
      *
     C     TimeOutStat   IFEQ      1331
     C     *IN99         ANDEQ     *ON
     C     *INKC         ANDEQ     *OFF
     C     *INKE         ANDEQ     *OFF
     C     *INKF         ANDEQ     *OFF
     C     *INKL         ANDEQ     *OFF
      *
     C                   EXSR      RSTRALL
     C                   EXSR      MOVEPARM
      *
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** Clear message
      *
     C                   EXSR      CLRMSG
      *
     C                   SELECT
     C                   WHEN      *INKC = *ON
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   WHEN      *INKE = *ON
     C                   MOVE      *BLANKS       WErrorFlag
     C                   EXSR      LOADARR
      *
     C                   OTHER
      *
      ** Validate screen input
      *
     C                   IF        WCount <> 0
     C                   EXSR      VALSCRN
      *
      ** If there are no errors, display 'Press F6 to Confirm
      ** or F12 to Cancel'
      *
     C                   IF        WErrorFlag = *BLANKS
     C                   EVAL      MessageID = 'CCS0026'
     C                   EVAL      MessageFile = 'GBMIDAS'
     C                   EXSR      ERRMSG
      *
      ** If F6 is pressed, process subfile
      *
     C                   IF        *INKF = *ON
     C                   EXSR      PRCSFL
     C                   ENDIF
      *
      ** If F12 is pressed, clear all error indicators and messages
      *
     C                   IF        *INKL = *ON
     C                   MOVE      *BLANKS       WErrorFlag
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EXSR      CLRMSG
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** LOADSFL - Load Subfile
      *****************************************************************
     C     LOADSFL       BEGSR
      *
      ** Clear subfile
      *
     C                   EXSR      CLRSFL
      *
      ** Initialise relative record number
      *
     C                   Z-ADD     0             WRRN
      *
      ** Set up message 'No Data To Display'
      *
     C                   IF        WCount = 0
     C                   EVAL      MessageID = 'DEP0003'
     C                   EVAL      MessageFile = 'GBMIDAS'
     C                   EXSR      ERRMSG
     C                   ENDIF
      *
      ** Initialise array index
      *
     C                   EVAL      I = 1
      *
     C                   DOW       I <= WCount
      *
     C                   EVAL      WRRN = WRRN + 1
      *
      ** Format display fields
      *
     C                   EXSR      FMTFLD
     C                   EVAL      *IN50 = *ON
      *
     C                   Z-ADD     WRRN          DDSFRN
      *
      ** If subfile relative record number is equal to record with error,
      ** seton error flags
      *
     C                   IF        DDSFRN = WSavRRN
      *
      ** If error in Restore Flag,
      *
     C                   IF        WErrRstFlg = 'Y'
     C                   EVAL      *IN21 = *ON
     C                   ENDIF
      *
      ** If error in To Library name,
      *
     C                   IF        WErrToLib  = 'Y'
     C                   EVAL      *IN22 = *ON
     C                   ENDIF
      *
      ** If error in Sequence Number
      *
     C                   IF        WErrSeqNum = 'Y'
     C                   EVAL      *IN23 = *ON
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   WRITE     SC000203S1
      *
      ** Set off error indicators
      *
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
      *
     C                   ADD       1             I
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** CLRSFL - Clear Subfile
      *****************************************************************
     C     CLRSFL        BEGSR
      *
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SC000203S0
     C                   EVAL      *IN97 = *OFF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** CLRARR - Clear Arrays
      *****************************************************************
     C     CLRARR        BEGSR
      *
     C                   MOVEA     *BLANKS       WRstLibArr
     C                   MOVEA     *BLANKS       WSchLibArr
     C                   MOVEA     *BLANKS       WLibDesArr
     C                   MOVEA     *BLANKS       WSavFilArr
     C                   MOVEA     *BLANKS       WToLibArr
     C                   MOVEA     *BLANKS       WSeqNumArr
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** FMTFLD - Format Field for Display Output
      *****************************************************************
     C     FMTFLD        BEGSR
      *
     C                   EVAL      DBRSTR = WRstLibArr(I)
     C                   EVAL      DBLIBN = WSchLibArr(I)
     C                   EVAL      DBLIBD = WLibDesArr(I)
     C                   EVAL      DBSAVF = WSavFilArr(I)
     C                   EVAL      DBTLIB = WToLibArr(I)
      *
      ** If restore from tape
      *
     C                   IF        *IN31 = *ON
     C                   EVAL      DBSEQN = WSeqNumArr(I)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** VALSCRN - Validate Screen Input
      *****************************************************************
     C     VALSCRN       BEGSR
      *
     C                   EVAL      I = 1
     C                   EVAL      DDSFRN = 1
     C                   MOVE      *BLANKS       WErrorFlag
      *
     C                   READC     SC000203S1                             60
      *
     C                   DOW       *IN60 = *OFF
      *
      ** Mark subfile record as changed
      *
     C                   EVAL      *IN50 = *ON
      *
      ** Determine if first error encountered
      *
     C                   IF        WErrorFlag = *BLANKS
      *
      ** Validate restore flag
      *
     C                   IF        DBRSTR <> 'Y' AND
     C                             DBRSTR <> 'N'
     C                   EVAL      WErrRstFlg = 'Y'
     C                   EVAL      MessageID = 'CPD2B12'
     C                   EVAL      MessageFile = 'QCPFMSG   '
     C                   EXSR      ERRMSG
     C                   ELSE
      *
      ** If restore flag is 'Y', validate other fields
      *
     C                   IF        DBRSTR = 'Y'
      *
      ** Validate To-Library
      *
     C                   IF        DBTLIB   = *BLANKS
     C                   EVAL      WErrToLib = 'Y'
     C                   EVAL      MessageID = 'CPDA965'
     C                   EVAL      MessageData = 'To-Library +
     C                                           Name'
     C                   EVAL      MessageFile = 'QCPFMSG   '
     C                   EXSR      ERRMSG
     C
     C                   ELSE
      *
      ** Check for libary existence
      *
     C                   EVAL      Library = %TRIML(DBTLIB)
     C                   CALL      'UTCHKOBJ'
     C                   PARM                    ExistCode
     C                   PARM                    Library
     C                   PARM      '*LIBL'       Qsys
     C                   PARM      '*LIB'        ObjType
     C                   PARM      '*NONE'       Member
      *
     C                   SELECT
     C                   WHEN      ExistCode = 'NotExist'
     C                   EVAL      WErrToLib = 'Y'
     C                   EVAL      MessageID = 'CPF2110'
     C                   EVAL      MessageData = Library
     C                   EVAL      MessageFile = 'QCPFMSG   '
     C                   EXSR      ERRMSG
     C                   WHEN      ExistCode = 'Error'
     C                   EVAL      WErrToLib = 'Y'
     C                   EVAL      MessageID = 'CPD6A74'
     C                   EVAL      MessageData = Library
     C                   EVAL      MessageFile = 'QCPFMSG   '
     C                   EXSR      ERRMSG
     C                   ENDSL
     C                   ENDIF
      *
      ** Validate Sequence Number
      *
     C                   IF        *IN31 = *ON AND
     C                             DBSEQN <> '*SEARCH'
      *
     C                   IF        DBSEQN = *BLANKS
     C                   EVAL      WErrSeqNum = 'Y'
     C                   EVAL      MessageID = 'CPDA965'
     C                   EVAL      MessageData = 'Sequence Number'
     C                   EVAL      MessageFile = 'QCPFMSG   '
     C                   EXSR      ERRMSG
      *
     C                   ELSE
     C                   Z-ADD     0             WNum
     C                   EVAL      WNum =  %CHECK('0123456789':%TRIM(DBSEQN))
     C                   IF        WNum > 0
     C                   EVAL      WErrSeqNum = 'Y'
     C                   EVAL      MessageID = 'CPD3260'
     C                   EVAL      MessageData = 'Sequence #'
     C                   EVAL      MessageFile = 'QCPFMSG   '
     C                   EXSR      ERRMSG
     C                   ELSE
     C                   Z-ADD     0             WSeqn
     C                   EVAL      WSeqn = %INT(DBSEQN)
      *
     C     WSeqn         IFLT      1
     C     WSeqn         ORGT      16777215
     C                   EVAL      WErrSeqNum = 'Y'
     C                   EVAL      MessageID = 'CPD3705'
     C                   EVAL      MessageFile = 'QCPFMSG   '
     C                   EXSR      ERRMSG
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If there is an error, save relative record number
      *
     C                   IF        WErrorFlag <> *BLANKS
     C                   MOVE      DDSFRN        WSavRRN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Move RRN to array index
      *
     C                   EVAL      I = DDSFRN
     C                   EXSR      LOADARR2
      *
      ** Update subfile record
      *
     C                   UPDATE    SC000203S1
     C                   READC     SC000203S1                             60
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** PRCSFL - Process Subfile Records
      *****************************************************************
     C     PRCSFL        BEGSR
      *
     C                   EVAL      DDSFRN = 1
     C                   EVAL      I = 1
      *
      ** Clear arrays
      *
     C                   EXSR      CLRARR
      *
     C                   READC     SC000203S1                             60
     C                   READ      SCBKLBL1                               96
      *
     C                   DOW       *IN60 = *OFF
     C     DBLIBN        CHAIN     SCBKLBL1                           89
      *
     C                   IF        *IN89 = *OFF
      *
      ** Save restore parameters to array
      *
     C                   EXSR      RSTRARR
      *
      ** Update Restore Flag
      *
     C                   EVAL      SLRSTR = DBRSTR
     C                   UPDATE    SCBKLBUPD
      *
     C                   READ      SCBKLBL1                               96
      *
     C                   ELSE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READC     SC000203S1                             60
      *
     C                   ENDDO
      *
     C                   EXSR      MOVEPARM
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** LOADARR2 - Load Array with Records from Subfile
      *****************************************************************
     C     LOADARR2      BEGSR
      *
     C                   EVAL      WRstLibArr(I) = DBRSTR
     C                   EVAL      WSchLibArr(I) = DBLIBN
     C                   EVAL      WLibDesArr(I) = DBLIBD
     C                   EVAL      WSavFilArr(I) = DBSAVF
     C                   EVAL      WToLibArr(I)  = DBTLIB
      *
     C                   IF        *IN31 = *ON
     C                   EVAL      WSeqNumArr(I) = DBSEQN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** RSTRARR - Load Array with Subfile Records for Restore
      *****************************************************************
     C     RSTRARR       BEGSR
      *
      ** If library is selected for restore,
      *
     C                   IF        DBRSTR = 'Y'
     C                   EVAL      WSchLibArr(I) = DBLIBN
     C                   EVAL      WSavFilArr(I) = DBSAVF
     C                   EVAL      WToLibArr(I)  = DBTLIB
      *
      ** If restore from tape,
      *
     C                   IF        *IN31 = *ON
     C                   EVAL      WSeqNumArr(I) = DBSEQN
     C                   ENDIF
      *
     C                   ADD       1             I
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** RSTRALL - Restore All Schemas/Libraries
      *****************************************************************
     C     RSTRALL       BEGSR
      *
     C                   EXSR      CLRARR
      *
     C     *LOVAL        SETLL     SCBKLBL0
      *
     C                   EVAL      I = 1
     C                   READ      SCBKLBL1                               96
      *
     C                   Z-ADD     0             WCount
      *
     C                   DOW       *IN96 = *OFF
      *
     C                   IF        SLSAVD = PBackUpTyp
      *
     C                   ADD       1             WCount
      *
      ** Copy records to array
      *
     C                   EVAL      WRstLibArr(I) = 'Y'
     C                   EVAL      WSchLibArr(I) = SLLIBN
     C                   EVAL      WLibDesArr(I) = SLLIBD
      *
     C                   SELECT
     C                   WHEN      WICT = 'Y'
     C                   EVAL      WSavFilArr(I) = SLICTS
     C                   WHEN      WBOB = 'Y'
     C                   EVAL      WSavFilArr(I) = SLBOBS
     C                   ENDSL
      *
     C                   EVAL      WToLibArr(I)  = SLLIBN
      *
      ** If restore from tape,
      *
     C                   IF        *IN31 = *ON
     C                   EVAL      WSeqNumArr(I) = '*SEARCH'
     C                   ENDIF
      *
      ** Update Restore Flag
      *
     C                   EVAL      SLRSTR = 'Y'
     C                   UPDATE    SCBKLBUPD
      *
     C                   ADD       1             I
      *
     C                   ENDIF
      *
     C                   READ      SCBKLBL1                               96
      *
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MOVEPARM - Pass Restore Details to Calling Program
      *****************************************************************
     C     MOVEPARM      BEGSR
      *
      ** Move values to parameters
      *
     C                   MOVEA     WSchLibArr    PSchemaLib
     C                   MOVEA     WSavFilArr    PSavFilNam
     C                   MOVEA     WToLibArr     PToLibrary
      *
      ** If restore from tape
      *
     C                   IF        *IN31 = *ON
     C                   MOVEA     WSeqNumArr    PSeqNumber
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PBackupTyp
     C                   PARM                    PDevDBSave
     C                   PARM                    PSchemaLib
     C                   PARM                    PSavFilNam
     C                   PARM                    PToLibrary
     C                   PARM                    PSeqNumber
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'SC000203'
      *
      ** Move workstation ID to screen field
      *
     C                   EVAL      DDWID = PsJobName
     C                   EVAL      DDUSER = PsUser
      *
     C                   EVAL      *IN25 = *ON
     C                   EVAL      DDPGMQ = '*'
      *
      ** Clear indicators
      *
     C                   MOVE      *BLANKS       WICT
     C                   MOVE      *BLANKS       WBOB
      *
      ** Clear arrays and output parameters
      *
     C                   EXSR      CLRARR
      *
     C                   EVAL      PSchemaLib = *BLANKS
     C                   EVAL      PSavFilNam = *BLANKS
     C                   EVAL      PToLibrary = *BLANKS
     C                   EVAL      PSeqNumber = *BLANKS
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **---------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** Functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **---------------------------------------------------------------

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** CLRMSG - Clear Program Message Queue
      *****************************************************************
     C     CLRMSG        BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcPgm     PgmQueue
     C                   PARM      '*SAME'       RelQueue
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** ERRMSG - Build Error Message Subfile
      *****************************************************************
     C     ERRMSG        BEGSR
      *
     C                   IF        PgmQueue = *BLANKS
     C                   EVAL      PgmQueue = PSProcPgm
     C                   ENDIF
      *
      ** Use standard program to send messages to program
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PgmQueue
     C                   PARM                    RelQueue
     C                   PARM                    MessageID
     C                   PARM                    MessageFile
     C                   PARM                    MessageData
     C                   PARM                    MessageType
      *
      * Reset fields for next call
      *
     C                   EVAL      PgmQueue = *blanks
     C                   EVAL      RelQueue = *blanks
     C                   EVAL      MessageID = *blanks
     C                   EVAL      MessageFile = *blanks
     C                   EVAL      MessageData = *blanks
     C                   EVAL      MessageType = *blanks
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      *****************************************************************
** CPY@
(c) Finastra International Limited 2011
