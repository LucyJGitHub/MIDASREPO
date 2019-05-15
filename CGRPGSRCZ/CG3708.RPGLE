     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Update correspondence item status')           *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3708 - Update Correspondence Item Status                   *
      *                                                               *
      *  Function: This module receives Feedback Log data from        *
      *            RPG/CG3707 and updates the correspondence          *
      *            Item Status in PF/CGUDCRPD or CGXDCRPD.            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR862117           Date 17Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 226341             Date 08Jul05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204987             Date 19Apr02               *
      *                 CCG015  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR862117 - CM_FEED is running but status remains 'PRTQ'      *
      *             (Child:AR862119)                                  *
      *  226341 - Allow the status of an item to change to 'PRTQ'     *
      *           upon requesting a management print for it.  Save    *
      *           current item status to unused field DRMSHT. Item    *
      *           status will be restored to this value after         *
      *           FormsMaster has finished processing this item.      *
      *         - Management print changes item status to 'PRTQ' then *
      *           'PRTD' and submits charges processing.              *
      *  204987 - Display the device name for message ID              *
      *           CGD2615 (Item processed by FormsMaster).            *
      *           Field DLMSDT was re-formatted.                      *
      *  CCG015 - Correspondence Manager (Phase 1)                    *
      *                                                               *
      *****************************************************************
      /EJECT
      * +------------------+
      * ¦ File declaration ¦
      * +------------------+
      *  UDC Data Reference (Current)
     FCGUDCRL0  UF   E           K DISK    COMMIT
 
      *  UDC Data Reference (Archive)
     FCGXDCRL0  UF   E           K DISK    COMMIT
 
      *  UDC Log File (Current)
     FCGUDCLL4  IF   E           K DISK
 
      *  UDC Log File (Archive)
     FCGXDCLL3  IF   E           K DISK
 
      * +--------------------+
      * ¦ Define work fields ¦
      * +--------------------+
     D ArchFlag        S              1
     D wFound          S              1
     D wNoOfPages      S              5
 
      * +---------------------------------+
      * ¦ Define Feedback Log file fields ¦
      * +---------------------------------+
     D CreateDate      S              8
     D CreateTime      S              6
     D CorrespID       S              8
     D DestCust        S             10
     D PDFName         S             35
     D PDFDir          S             75
     D PrintDate       S              8
     D PrintTime       S              6
     D Device          S             15
     D NoOfPages       S              5
 
      * +-------------------------------------+
      * ¦ Variables for writing into Log file ¦
      * +-------------------------------------+
     D L#Rtcd          S              7    INZ(*BLANKS)
     D L#Actn          S              8    INZ(*BLANKS)
     D L#UDCL        E DS                  EXTNAME(CGUDCLPD)
     D L#Titl          S              7    INZ(*BLANKS)
     D L#Ulin          S              7    INZ(*BLANKS)
     D L#Cmt           S              3    INZ(*BLANKS)
 
      * +------------------------+
      * ¦ Define Parameter List  ¦
      * +------------------------+
     D DataArr         S             75    DIM(10)
     D ReturnCode      S             10
 
      * +-----------------+
      * ¦ Define Key List ¦
      * +-----------------+
     DKYItem           S                   LIKE(DLITEM)
     DKYDCor           S                   LIKE(DLDCOR)
 
      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
     D BlankChar       C                   ' '
     D PrintQueue      C                   'PRTQ'
     D Printed         C                   'PRTD'
      * Message Text : 'Item printed by FormsMaster.'
     D MSGIDPrtd       C                   'CGD2615'
 
      * +---------------------------------------------------+
      * ¦ Function to Right Align 5-long alphanumeric field ¦
      * +---------------------------------------------------+
     DAlignFld         PR             5
     D wField2                        5    VALUE
 
      * +----------------------------------+
      * ¦ For *PSSR Error Handling routine ¦
      * +----------------------------------+
     D @Run            S              1
 
      * +------------------------------------------------------+
      * ¦ Local Data Area Structure for error handling routine ¦
      * +------------------------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *  LDA definition :                   134 141 DBFILE
      *                                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *                                     184 193 DBMOD
      *                                     194 203 DBPROC
 
      * +-----------------------------------------------------------------+
      * ¦ The following /COPY line includes all the defined fields in the ¦
      * ¦ PSDS.  They have meaningful names, prefixed by 'PS'.            ¦
      * +-----------------------------------------------------------------+
     D/COPY ZACPYSRC,PSDS
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Main Routine                                                ¦
      * +-------------------------------------------------------------+
 
      * Receive Feedback data
 
     C                   EXSR      RecvData
 
      * Determine if Feedback data is for Current or Archive item.
 
     C                   EVAL      wFound = 'N'
     C                   EXSR      ScanLogFile
 
     C                   IF        wFound = 'Y'
 
      * Update the UDC Ref file ONLY if the Item is found in UDC Log.
      * If the Feedback data does not correspond to an Item in the
      * iSeries (i.e. test messages produced in FormsMaster), skip
      * this record and process the next one.
 
     C                   EXSR      UpdatStatus
 
      * Create new Feedback log record indicating Item has been
      * printed successfully by FormsMaster
 
     C                   EXSR      WriteLogRcd
 
     C                   ENDIF
 
 
     C                   SETON                                        LR
      *---------------------------------------------------------------*
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/RecvData    - Receive Feedback data passed from        ¦
      * ¦                    calling program.                         ¦
      * +-------------------------------------------------------------+
     C     RecvData      BEGSR
 
     C                   EVAL      CreateDate  = DataArr(1)
     C                   EVAL      CreateTime  = DataArr(2)
     C                   EVAL      CorrespID   = DataArr(3)
     C                   EVAL      DestCust    = DataArr(4)
     C                   EVAL      PDFName     = DataArr(5)
     C                   EVAL      PDFDir      = DataArr(6)
     C                   EVAL      PrintDate   = DataArr(7)
     C                   EVAL      PrintTime   = DataArr(8)
     C                   EVAL      Device      = DataArr(9)
     C                   EVAL      NoOfPages   = DataArr(10)
 
     C                   ENDSR
      * +------------------------------------------------------------------+
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/ScanLogFile - Determine if Feedback data is for a      ¦
      * ¦                    CURRENT or ARCHIVE correspondence. Also  ¦
      * ¦                    update field PDF file known for the      ¦
      * ¦                    record.                                  ¦
      * +-------------------------------------------------------------+
     C     ScanLogFile   BEGSR
 
      * Initialise key field for UDC log files.
 
     C                   MOVEL     CorrespID     KYItem
     C                   MOVEL     DestCust      KYDCor
 
      * +-------------------------+
      * ¦ Search Current Log File ¦
      * +-------------------------+
 
     C     CorrKey1      SETLL     CGUDCLL4
 
     C                   IF        %EQUAL
      * Set Item Found indicator
     C                   EVAL      wFound = 'Y'
      * Set Archive flag to NO.
     C                   EVAL      ArchFlag = 'N'
 
     C                   ELSE
 
      * +-------------------------+
      * ¦ Search Archive Log File ¦
      * +-------------------------+
 
     C     CorrKey1      SETLL     CGXDCLL3
 
     C                   IF        %EQUAL
      * Set Item Found indicator
     C                   EVAL      wFound = 'Y'
      * Set Archive flag to YES.
     C                   EVAL      ArchFlag = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      * +------------------------------------------------------------------+
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/UpdatStatus - Update Item Status field for the         ¦
      * ¦                    correspondence.                          ¦
      * +-------------------------------------------------------------+
     C     UpdatStatus   BEGSR
 
      * Search Current Reference File if Archive Flag if *OFF.
 
     C                   IF        ArchFlag <> 'Y'
 
     C     CorrKey1      CHAIN     CGUDCRL0                           91
 
     C                   IF        (*IN91 = *OFF) AND (DRISTS = PrintQueue)
     C     DRMSHT        IFEQ      *BLANKS                                                    226341
     C     DRMSHT        OREQ      'PRTQ'                                                   AR862117
     C                   EVAL      DRISTS = Printed
     C                   MOVEL     *BLANKS       DRMSHT                                     AR862117
     C                   ELSE                                                                 226341
     C                   MOVEL     DRMSHT        DRISTS                                       226341
     C                   MOVEL     *BLANKS       DRMSHT                                       226341
     C                   ENDIF                                                                226341
     C                   UPDATE    @UDCRL0
     C                   ENDIF
 
     C                   ELSE
 
      * Search Archive Reference File if Archive Flag is *ON.
 
     C     CorrKey1      CHAIN     CGXDCRL0                           91
 
     C                   IF        (*IN91 = *OFF) AND (DRISTS = PrintQueue)
     C     DRMSHT        IFEQ      *BLANKS                                                    226341
     C     DRMSHT        OREQ      'PRTQ'                                                   AR862117
     C                   EVAL      DRISTS = Printed
     C                   MOVEL     *BLANKS       DRMSHT                                     AR862117
     C                   ELSE                                                                 226341
     C                   MOVEL     DRMSHT        DRISTS                                       226341
     C                   MOVEL     *BLANKS       DRMSHT                                       226341
     C                   ENDIF                                                                226341
     C                   UPDATE    @XDCRL0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      * +------------------------------------------------------------------+
 
      /EJECT
      * +--------------------------------------------------------------+
      * ¦ Subr/WriteLogRcd - Generate Feedback log record for the Item ¦
      * ¦                    to indicate that it has been printed by   ¦
      * ¦                    FormsMaster.                              ¦
      * +--------------------------------------------------------------+
     C     WriteLogRcd   BEGSR
 
      * Initialise CGUDCLPD work format
 
     C                   CLEAR                   L#UDCL
 
      * Set up Log file field values.
 
     C                   MOVEL     CorrespID     DLITEM
     C                   EVAL      DLDCOR = %TRIM(DestCust)
     C                   IF        DRISTS  = Printed                                          226341
     C                   EVAL      DLMSID = MSGIDPrtd
     C                   ELSE                                                                 226341
     C                   EVAL      DLMSID = 'CGD2624'                                         226341
     C                   ENDIF                                                                226341
     C*******************EVAL      DLMSDT = %TRIM(PDFDir) + %TRIM(PDFName) +    204987
     C*******************                   %TRIM(Device)                       204987
     C                   EVAL      DLMSDT = Device + PDFDir + PDFName           204987
     C                   EVAL      DLCPGM = 'CG3707'
     C                   EVAL      DLRPGM = 'CG3708'
 
      * Set up Feedback data fields.
 
     C                   EVAL      DLPROC = 'Y'
     C                   EVAL      DLPDFN = %TRIM(PDFName)
     C                   EVAL      DLPDFD = %TRIM(PDFDir)
     C                   EVAL      DLPRTD = %TRIM(PrintDate)
     C                   EVAL      DLPRTT = %TRIM(PrintTime)
     C                   EVAL      DLDEVN = %TRIM(Device)
 
      * Right justify No. Of Pages field before writing to file.
 
     C                   EVAL      wNoOfPages = AlignFld(NoOfPages)
     C                   MOVE      wNoOfPages    DLNOPG
 
      * Blank out / zeroised those fields used by original UDC module
      * as they are no longer used in Correspondence Manager.
 
     C                   EVAL      DLSPLF = *BLANKS
     C                   EVAL      DLSPLN = 0
     C                   EVAL      DLSJOB = *BLANKS
     C                   EVAL      DLSUSR = *BLANKS
     C                   EVAL      DLSJNO = 0
     C                   EVAL      DLSPGE = 0
     C                   EVAL      DLEPGE = 0
 
      * Call Program to write the log record.
 
      * Write to Archive log file
      * -------------------------
 
     C                   IF        ArchFlag = 'Y'
 
     C                   CALL      'CG9050'
     C                   PARM      *BLANKS       L#Rtcd
     C                   PARM      '*WRITE  '    L#Actn
     C                   PARM                    L#UDCL
     C                   PARM      *BLANKS       L#Titl
     C                   PARM      *BLANKS       L#Ulin
     C                   PARM      'YES'         L#Cmt
 
      * Write to Current log file
      * -------------------------
 
     C                   ELSE
     C                   CALL      'CG9030'
 
     C                   PARM      *BLANKS       L#Rtcd
     C                   PARM      '*WRITE  '    L#Actn
     C                   PARM                    L#UDCL
     C                   PARM      *BLANKS       L#Titl
     C                   PARM      *BLANKS       L#Ulin
     C                   PARM      'YES'         L#Cmt
     C                   ENDIF
 
      * If error encountered, process database erro.
 
     C                   IF        L#Rtcd <> *BLANKS
 
      * Identify file involved based on Archive flag
 
     C                   IF        ArchFlag = 'Y'
     C                   EVAL      DBFILE = 'CGXDCLL3'
     C                   ELSE
     C                   EVAL      DBFILE = 'CGUDCLL4'
     C                   ENDIF
 
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      * +------------------------------------------------------------------+
 
      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/*INZSR - Initialisation subroutine                          ¦
      * +------------------------------------------------------------------+
     C     *INZSR        BEGSR
 
      *  Define parameter passed from calling program.
 
     C     *ENTRY        PLIST
     C                   PARM                    DataArr
     C                   PARM                    ReturnCode
 
      *  Define Key list for Item Log file search.
 
     C     CorrKey1      KLIST
     C                   KFLD                    KYItem
     C                   KFLD                    KYDCor
 
     C                   ENDSR
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/*PSSR - Program Exception Error Handling Routine       ¦
      * ¦              Called automatically if a program error occurs,¦
      * ¦              or directly by the program code using EXSR.    ¦
      * ¦              This subroutine DUMPs the program just once.   ¦
      * +-------------------------------------------------------------+
     C     *PSSR         BEGSR
 
      *  Dump the program
     C                   DUMP
 
      *  Display Dbase Error screen
     C                   IF        @Run = *BLANK
     C                   EVAL      @Run = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
      * Set job switches
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   EVAL      ReturnCode = '*ERROR    '
 
      * End program
     C                   RETURN
 
     C                   ENDSR
 
      /EJECT
      * +----------------------------------------------------------+
      * ¦ Func/AlignFld - Right justify alphanumeric field values. ¦
      * +----------------------------------------------------------+
     PAlignFld         B
 
     DAlignFld         PI             5
     D  wField1                       5    VALUE
 
      * Work fields to hold trimmed data
     D wChar1          S              1
     D wChar2          S              2
     D wChar3          S              3
     D wChar4          S              4
     D wChar5          S              5
 
     D wLen            S              2  0
 
      * Field to contain right justified data.
 
     D wField2         S              5    INZ(*BLANK)
 
      * Determine actual length of field.
 
     C     BlankChar     CHECKR    wField1       wLen
 
     C                   IF        wLen = 5
     C                   EVAL      wChar5 = %SUBST(wField1:1:wLen)
     C                   MOVE      wChar5        wField2
     C                   ENDIF
 
     C                   IF        wLen = 4
     C                   EVAL      wChar4 = %SUBST(wField1:1:wLen)
     C                   MOVE      wChar4        wField2
     C                   ENDIF
 
     C                   IF        wLen = 3
     C                   EVAL      wChar3 = %SUBST(wField1:1:wLen)
     C                   MOVE      wChar3        wField2
     C                   ENDIF
 
     C                   IF        wLen = 2
     C                   EVAL      wChar2 = %SUBST(wField1:1:wLen)
     C                   MOVE      wChar2        wField2
     C                   ENDIF
 
     C                   IF        wLen = 1
     C                   EVAL      wChar1 = %SUBST(wField1:1:wLen)
     C                   MOVE      wChar1        wField2
     C                   ENDIF
 
     C                   RETURN    wField2
     P                 E
