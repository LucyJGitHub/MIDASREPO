     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas CG Stream File Generators')                      *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3625 - XML Stream File Generator program                   *
      *                                                               *
      *  Function: This module creates a stream file (type *STMF)     *
      *  and writes compressed XML data (from PF/CGUXMLPD) to it.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD053A            Date 14Dec12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 235560             Date 29Sep05               *
      *                 CSD053             Date 01Jun06               *
      *                 226341             Date 08Jul05               *
      *                 BUG7529            Date 13Jun05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD053A - Correspondence Manager DBCS Support                *
      *            Applied for AR924785 (Child: AR924788)             *
      *  235560 - Extend BUG7529 to 30 seconds.                       *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *  226341 - Allow the status of an item to change to 'PRTQ'     *
      *           upon requesting a management print for it.  Save    *
      *           current item status to unused field DRMSHT. Item    *
      *           status will be restored to this value after         *
      *           FormsMaster has finished processing this item.      *
      *         - Management print changes item status to 'PRTQ' then *
      *           'PRTD' and submits charges processing.              *
      *  BUG7529 - Getting resource unavailable error in DBAS 002     *
      *            Program could be running too fast for the machine. *
      *            If error encountered delay and retry.              *
      *  CCG015 - Correspondence Manager                              *
      *                                                               *
      *****************************************************************
      /EJECT
      * +------------------+
      * ¦ File declaration ¦
      * +------------------+
 
      *  UDC Data Reference Log file
     FCGUDCRL0  UF   E           K DISK    USROPN COMMIT
 
      *  UDC Archive Data Reference Log file
     FCGXDCRL0  UF   E           K DISK    USROPN COMMIT
 
      /EJECT
      * +--------------------------------------+
      * ¦ Prototypes required for the IFS APIs ¦
      * +--------------------------------------+
      /COPY CGCPYSRC,IFSPROTO
 
      * +------------------------------------------------------+
      * ¦ READ API() definitions for oflag and mode parameters ¦
      * +------------------------------------------------------+
      /COPY CGCPYSRC,OPENDFN
 
      * +-------------------------------------------------+
      * ¦ Variable declaration for the IFS APIs used here ¦
      * +-------------------------------------------------+
     D FDescDat        S             10I 0
     D FDescCtl        S             10I 0
     D Oflag           S             10I 0 INZ
     D Mode            S             10I 0 INZ
     D RC              S             10I 0
     D*Codepage*       S              3  0                                                    CSD053
     D Ccsid           S              5  0                                                    CSD053
 
      * +-------------------------+
      * ¦ Other standalone fields ¦
      * +-------------------------+
     D PathName        S            100A   INZ(*BLANKS)
     D AttNbr          S             35A
     D RtnCode         S              7A
     D ActCode         S              6A
     D StmfName        S             30A   INZ(*BLANKS)
     D WFirst          S              1A
     D WClose          S              1A
 
      * +-------------------------------------+
      * ¦ Variables for writing into Log file ¦
      * +-------------------------------------+
     D L#Rtcd          S              7    INZ(*BLANKS)
     D L#Actn          S              8    INZ(*BLANKS)
     D L#UDCL        E DS                  EXTNAME(CGUDCLPD)
     D L#Titl          S              7    INZ(*BLANKS)
     D L#Ulin          S              7    INZ(*BLANKS)
     D L#Cmt           S              3    INZ(*BLANKS)
 
      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
     D ExtDAT          C                   CONST('.DAT')
     D ExtCTL          C                   CONST('.CTL')
     D CRLF            C                   X'0D25'
     D Null            C                   X'00'
 
      * +----------------------------------+
      * ¦ For *PSSR Error Handling routine ¦
      * +----------------------------------+
     D @RUN            S              1
 
      * +-------------------------+
      * ¦ Parameters for AOCORMR0 ¦
      * +-------------------------+
     D Rtcd            S              7    INZ(*BLANK)
     D Optn            S              7    INZ(*BLANK)
 
      * +------------------------+
      * ¦ Parameters for CGC3608 ¦
      * +------------------------+
     D F#Rtn           S             10    INZ(*BLANK)
     D F#Act           S             10    INZ(*BLANK)
      *                                                                                      CSD053A
      ** Parameters for AOSVALR0                                                             CSD053A
      *                                                                                      CSD053A
     D P@OP01          S             20    INZ                                               CSD053A
     D P@VL01          S            200    INZ                                               CSD053A
     D P@OP02          S                   LIKE(P@OP01) INZ                                  CSD053A
     D P@VL02          S                   LIKE(P@VL01) INZ                                  CSD053A
     D P@OP03          S                   LIKE(P@OP01) INZ                                  CSD053A
     D P@VL03          S                   LIKE(P@VL01) INZ                                  CSD053A
     D P@OP04          S                   LIKE(P@OP01) INZ                                  CSD053A
     D P@VL04          S                   LIKE(P@VL01) INZ                                  CSD053A
     D P@OP05          S                   LIKE(P@OP01) INZ                                  CSD053A
     D P@VL05          S                   LIKE(P@VL01) INZ                                  CSD053A
     D P@OP06          S                   LIKE(P@OP01) INZ                                  CSD053A
     D P@VL06          S                   LIKE(P@VL01) INZ                                  CSD053A
     D P@OP07          S                   LIKE(P@OP01) INZ                                  CSD053A
     D P@VL07          S                   LIKE(P@VL01) INZ                                  CSD053A
     D P@OP08          S                   LIKE(P@OP01) INZ                                  CSD053A
     D P@VL08          S                   LIKE(P@VL01) INZ                                  CSD053A
     D P@OP09          S                   LIKE(P@OP01) INZ                                  CSD053A
     D P@VL09          S                   LIKE(P@VL01) INZ                                  CSD053A
     D P@OP10          S                   LIKE(P@OP01) INZ                                  CSD053A
     D P@VL10          S                   LIKE(P@VL01) INZ                                  CSD053A
     D I#Rtcd          S              7    INZ(*BLANK)                                       CSD053A
      *                                                                                      CSD053A
     D CodePage        S              3P 0                                                   CSD053A
     D AllowDBCS       S              1                                                      CSD053A
 
      * +---------------------------------------------------------+
      * ¦ Function to retrieve next Streamfile Attribution Number ¦
      * +---------------------------------------------------------+
     DGetAttNbr        PR            35
 
      * +--------------------------------------------------------+
      * ¦ Data structure to set up Message Data for the log file ¦
      * +--------------------------------------------------------+
     D L#MSDT          DS
     D L#ITEM                  1      5P 0
     D L#DCOR                  6     15
 
      * +----------------------------------------------+
      * ¦ Data structure for Print Process driver file ¦
      * +----------------------------------------------+
     D PrtGen        E DS                  EXTNAME(CGPGENPD)
 
      * +-----------------------------------------------+
      * ¦ Data structure for Correspondence Manager ICD ¦
      * +-----------------------------------------------+
     D Sdcorm        E DS                  EXTNAME(SDCORMPD)
 
      * +-----------------------------------------------+
      * ¦ Data Structure (long) used by Access Programs ¦
      * +-----------------------------------------------+
     D Dsldy         E DS                  EXTNAME(DSLDY)
 
      * +----------------------------------------------------+
      * ¦ System Local Data Area to hold <OutputInformation> ¦
      * +----------------------------------------------------+
     D Cglda         E DS                  EXTNAME(CGLDA)
 
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
      * +------------------------------------------------------------------+
      * ¦ Main Routine                                                     ¦
      * +------------------------------------------------------------------+
      *
      ** Access the system value                                                             CSD053A
      *                                                                                      CSD053A
     C                   EVAL      P@OP01 = 'CSD053AllowDBCS'                                CSD053A
      *                                                                                      CSD053A
     C                   CALL      'AOSVALR0'                                                CSD053A
     C                   PARM      *BLANKS       I#Rtcd                                      CSD053A
     C                   PARM                    P@OP01                                      CSD053A
     C                   PARM      *BLANKS       P@VL01                                      CSD053A
     C                   PARM      *BLANKS       P@OP02                                      CSD053A
     C                   PARM      *BLANKS       P@VL02                                      CSD053A
     C                   PARM      *BLANKS       P@OP03                                      CSD053A
     C                   PARM      *BLANKS       P@VL03                                      CSD053A
     C                   PARM      *BLANKS       P@OP04                                      CSD053A
     C                   PARM      *BLANKS       P@VL04                                      CSD053A
     C                   PARM      *BLANKS       P@OP05                                      CSD053A
     C                   PARM      *BLANKS       P@VL05                                      CSD053A
     C                   PARM      *BLANKS       P@OP06                                      CSD053A
     C                   PARM      *BLANKS       P@VL06                                      CSD053A
     C                   PARM      *BLANKS       P@OP07                                      CSD053A
     C                   PARM      *BLANKS       P@VL07                                      CSD053A
     C                   PARM      *BLANKS       P@OP08                                      CSD053A
     C                   PARM      *BLANKS       P@VL08                                      CSD053A
     C                   PARM      *BLANKS       P@OP09                                      CSD053A
     C                   PARM      *BLANKS       P@VL09                                      CSD053A
     C                   PARM      *BLANKS       P@OP10                                      CSD053A
     C                   PARM      *BLANKS       P@VL10                                      CSD053A
      *                                                                                      CSD053A
     C                   IF        I#Rtcd <> *BLANKS                                         CSD053A
     C                   EVAL      DBFILE =  'SDSVALPD'                                      CSD053A
     C                   EVAL      DBPGM  =  P@OP01                                          CSD053A
     C                   EVAL      DBASE  =  014                                             CSD053A
     C                   EVAL      DBMOD  =  PSProcMod                                       CSD053A
     C                   EXSR      *PSSR                                                     CSD053A
     C                   ENDIF                                                               CSD053A
      *                                                                                      CSD053A
     C                   MOVEL     P@VL01        AllowDBCS                                   CSD053A
                                                                                             CSD053A
     C                   SELECT
      *  Mode = *WRITE
      *  -------------
     C                   WHEN      ActCode = '*WRITE'
 
      *  Only create stream file and write <Correspondent> line if
      *  program is called for the first time to write or if previous
      *  stream was successfully closed (this is for multi-message
      *  processing where 1st streamfile already holds the maximum
      *  number of export file size defined).
     C                   IF        (WFirst = 'Y') OR (WClose = 'Y')
 
      *  Retrieve the next available Streamfile Attribution No.
     C                   EVAL      AttNbr = GetAttNbr
 
      *  Create the Streamfile
     C                   EXSR      CREATESTMF
 
      *  Open stream file and write first line (i.e. '<Correspondence>')
     C                   EXSR      WRITEFIRST
 
     C                   ENDIF
 
      *  Write data into Streamfile
     C                   EXSR      WRITESTMF
 
      *  Output Log record for this item
     C                   EXSR      WRITELOG
 
      *  Update WClose flag to 'N'
     C                   EVAL      WClose = 'N'
 
      *  Mode = *CLOSE
      *  -------------
     C                   WHEN      ActCode = '*CLOSE'
 
      *  Close the Streamfile .DAT
     C                   EXSR      CLOSESTMF
 
      *  Submit the FTP job (if not already running)
     C                   EXSR      RUNFTP
 
      *  Update WClose flag to 'N'
     C                   EVAL      WClose = 'Y'
 
     C                   ENDSL
 
      *  Update WFirst flag to 'N'
     C                   EVAL      WFirst = 'N'
 
      *  Terminate the program
     C                   RETURN
 
      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/*INZSR - Initialisation subroutine                          ¦
      * +------------------------------------------------------------------+
     C     *INZSR        BEGSR
 
      * List of program parameters :
      * --------------------------
      * a) RtnCode - normally *BLANK at entry
      * b) ActCode - should be either *GEN, *WRITE or *CLOSE
      * c) PrtGen - a data structure containing entire data record
      *             from PF/CGPGENPD
 
     C     *ENTRY        PLIST
     C                   PARM                    RtnCode
     C                   PARM                    ActCode
     C                   PARM                    PrtGen
 
      *  Initialise control flags
     C                   EVAL      WFirst = 'Y'
     C                   EVAL      WClose = 'N'
 
      *  Define work dataarea
     C     *DTAARA       DEFINE    *LDA          Cglda
 
      *  Define Key for creating Item Log record
     C     UDCRKY        KLIST
     C                   KFLD                    B2ITEM
     C                   KFLD                    B2DCOR
 
      *  Retrieve Correspondence Manager ICD
     C                   CALLB(E)  'AOCORMR0'
     C                   PARM      *BLANKS       Rtcd
     C                   PARM      '*FIRST '     Optn
     C     Sdcorm        PARM      *BLANKS       Dsldy
 
      * Error calling AOCORMR0
     C                   IF        %ERROR OR Rtcd <> *BLANK
     C                   EVAL      DBFILE =  'SDCORMPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Initialise the code page for stream file representation
     C**********         MOVE      CMCPAG        CodePage                                     CSD053
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   MOVE      CMFCCS        Ccsid                                        CSD053
     C                   ELSE                                                                CSD053A
     C                   MOVE      CMCPAG        CodePage                                    CSD053A
     C                   ENDIF                                                               CSD053A
 
     C                   ENDSR
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/CREATESTMF - Create streamfile (type *STMF) in         ¦
      * ¦                   exclusive mode.                           ¦
      * +-------------------------------------------------------------+
     C     CREATESTMF    BEGSR
 
      *  Define the streamfile name (AttnNbr + '.DAT').
     C                   EVAL      StmfName = %TRIM(AttNbr) + ExtDAT
 
      *  Define the path using the Local Directory entry in ICD
     C                   EVAL      PathName =
     C                               %TRIM(CMLODI) + '/' + %TRIM(StmfName)
 
      *  CREATE THE STREAM FILE
      *  ----------------------
      *  Set file status flag for creation of stream file where the file
      *  is opened for writing only and not shared (i.e. exclusive for
      *  this process).
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      Oflag = O_CREATE + O_WRONLY +
     C**********                           O_SHARE_NONE + O_CODEPAGE                          CSD053
     C                                     O_SHARE_NONE + O_CCSID                             CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      Oflag = O_CREATE + O_WRONLY +                             CSD053A
     C                                     O_SHARE_NONE + O_CODEPAGE                         CSD053A
     C                   ENDIF                                                               CSD053A
                                                                                             CSD053A
      * Set file mode parameter
     C                   EVAL      mode = S_IRWXU + S_IRWXG +
     C                                    S_IROTH + S_IXOTH
 
      * Create stream file
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      FDescDat = OPEN(%TRIMR(PathName) :
     C**********                            Oflag : mode : Codepage)                          CSD053
     C                                      Oflag : mode : Ccsid)                             CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      FDescDat = OPEN(%TRIMR(PathName) :                        CSD053A
     C                                      Oflag : mode : Codepage)                         CSD053A
     C                   ENDIF                                                               CSD053A
                                                                                             BUG7529
      * If error creating the Streamfile wait one second and retry.                          BUG7529
      ** retry xx times.                                                                      235560
                                                                                              235560
     C                   Z-ADD     0             W#CNT             5 0                        235560
     C**********         IF        FDescDat = -1                                      BUG7529 235560
     C     FDescDat      DOWEQ     -1                                                         235560
     C     W#CNT         ANDLE     30                                                         235560
     C                   MOVE      '1     '      WAIT                                        BUG7529
     C                   CALL      'GLDLYJOB'                                                BUG7529
     C                   PARM                    WAIT              6                         BUG7529
      *                                                                                      BUG7529
      * Re-try creating the Streamfile                                                       BUG7529
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      FDescDat = OPEN(%TRIMR(PathName) :                        BUG7529
     C**********                            Oflag : mode : Codepage)                  BUG7529 CSD053
     C                                      Oflag : mode : Ccsid)                     BUG7529 CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      FDescDat = OPEN(%TRIMR(PathName) :                        CSD053A
     C                                      Oflag : mode : Codepage)                         CSD053A
     C                   ENDIF                                                               CSD053A
     C                   ADD       1             W#CNT                                        235560
     C                   ENDDO                                                                235560
     C**********         ENDIF                                                        BUG7529 235560
 
      * If error creating the Streamfile
      * after the re-try, then this is not an issue of trying too soon, database error.      BUG7529
     C                   IF        FDescDat = -1
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WRITEFIRST - Write data from Merged XML Data (CGUXMLPD)¦
      * ¦                   file into the stream file.                ¦
      * +-------------------------------------------------------------+
     C     WRITEFIRST    BEGSR
 
     C                   CALLB     'CG3626'
     C                   PARM      '*GEN  '      ActCode
     C                   PARM                    PrtGen
     C                   PARM                    FDescDat
     C                   PARM      *BLANKS       RtnCode
     C                   PARM                    AllowDBCS                                   CSD053A
 
      *  If return code is not blank or *ERROR, process dbase error.
     C                   IF        RtnCode <> *BLANKS
     C                             AND RtnCode = '*ERROR '
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  005
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WRITESTMF - Write data from Merged XML Data (CGUXMLPD) ¦
      * ¦                  file into the stream file.                 ¦
      * +-------------------------------------------------------------+
     C     WRITESTMF     BEGSR
 
      *  Write Merged XML data into Stream file.
 
     C                   CALLB     'CG3626'
     C                   PARM      '*WRITE'      ActCode
     C                   PARM                    PrtGen
     C                   PARM                    FDescDat
     C                   PARM      *BLANKS       RtnCode
     C                   PARM                    AllowDBCS                                   CSD053A
 
      *  If return code is not blank or *ERROR, process dbase error.
     C                   IF        RtnCode <> *BLANKS
     C                             AND RtnCode = '*ERROR '
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  006
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/CLOSESTMF - Wrap the stream file by writing line       ¦
      * ¦                  '</Correspondent>' then close it using     ¦
      * ¦                  IFS API CLOSE()function.                   ¦
      * +-------------------------------------------------------------+
     C     CLOSESTMF     BEGSR
 
      *  Wrap correspondent data in the stream file and close it.
 
     C                   CALLB     'CG3626'
     C                   PARM      '*CLOSE'      ActCode
     C                   PARM                    PrtGen
     C                   PARM                    FDescDat
     C                   PARM      *BLANKS       RtnCode
     C                   PARM                    AllowDBCS                                   CSD053A
 
      *  If return code is not blank or *ERROR, process dbase error.
     C                   IF        RtnCode <> *BLANKS
     C                             AND RtnCode = '*ERROR '
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  007
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *  Create control file .CTL before closing .DAT file
     C                   EXSR      CREATECTL
 
      *  Now close the .DAT file
     C                   EVAL      RC = CLOSE(FDescDat)
 
      *  If error closing the streamfile, process dbase error.
     C                   IF        RC = -1
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  008
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/CREATECTL - Create .CTL control file to indicate       ¦
      * ¦                  that writing to streamfile .DAT is now     ¦
      * ¦                  complete.                                  ¦
      * +-------------------------------------------------------------+
     C     CREATECTL     BEGSR
 
      *  Define the control streamfile name (AttnNbr + '.CTL').
     C                   EVAL      StmfName = %TRIM(AttNbr) + ExtCTL
     C                   EVAL      PathName =
     C                               %TRIM(CMLODI) + '/' + %TRIM(StmfName)
 
      *  Create the control file .CTL
      *  ----------------------------
      *  Set file status flag for stream file creation where the file is
      *  open for both reading and writing, a codepage will be specified
      *  in the codepage parameter and if the file exist, its size will
      *  be truncated to zero (cleared)
     C                   EVAL      Oflag = O_CREATE + O_WRONLY +
     C                                     O_TEXTDATA + O_SHARE_NONE
      * Set file mode parameter
     C                   EVAL      Mode = S_IRWXU + S_IRWXG +
     C                                    S_IROTH + S_IXOTH
 
      * Create stream file
     C                   IF        AllowDBCS = 'Y'                                           CSD053A
     C                   EVAL      FDescCtl = OPEN(%TRIMR(PathName) :
     C**********                            Oflag : Mode : Codepage)                          CSD053
     C                                      Oflag : Mode : Ccsid)                             CSD053
     C                   ELSE                                                                CSD053A
     C                   EVAL      FDescCtl = OPEN(%TRIMR(PathName) :                        CSD053A
     C                                      Oflag : Mode : Codepage)                         CSD053A
     C                   ENDIF                                                               CSD053A
 
      *  If error creating the streamfile, process dbase error.
     C                   IF        FDescCtl = -1
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  009
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ELSE
 
      *  Close .CTL file without writing anything to it.
 
     C                   EVAL      RC = CLOSE(FDescCtl)
 
      *  If error closing the streamfile, process dbase error.
     C                   IF        RC = -1
     C                   EVAL      DBFILE =  *BLANK
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  010
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/RUNFTP - Submit FTP Job CGC3608.                       ¦
      * +-------------------------------------------------------------+
     C     RUNFTP        BEGSR
 
      *  Call CGC3608 to submit the FTP job.
 
     C                   CALL      'CGC3608'
     C                   PARM      *BLANKS       F#Rtn
     C                   PARM      '*START    '  F#Act
 
      *  Action *START will try to allocate SDCORMPD file to ensure
      *  that FTP job will not run while this ICD file is being amended.
      *  If the file can not be allocated, process dbase error and dump
      *  the program.
     C                   IF        F#Rtn = '*ERROR '
     C                   EVAL      DBFILE =  'SDCORMPD'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  011
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/WRITELOG - Output Log record either in PF/CGUDCLPD     ¦
      * ¦                 or PF/CGXDCLPD depending on setting of      ¦
      * ¦                 Archive Flag.                               ¦
      * +-------------------------------------------------------------+
     C     WRITELOG      BEGSR
 
      *  Read-in *LDA
     C                   IN        Cglda
 
      *  Open any of the two Log files depending on Archive flag
      *  from dataarea Cglda
     C                   IF        #@ARCH = 'A'
     C                   OPEN      CGXDCRL0
     C                   ELSE
     C                   OPEN      CGUDCRL0
     C                   ENDIF
 
      *  Access the UDC Reference file for the Correspondence Item
     C                   IF        #@ARCH = 'A'
     C     UDCRKY        CHAIN     CGXDCRL0                           50
     C                   ELSE
     C     UDCRKY        CHAIN     CGUDCRL0                           50
     C                   ENDIF
 
      *  If record is not found, process database error.
     C                   IF        *IN50 = '1'
 
     C                   IF        #@ARCH = 'A'
     C                   EVAL      DBFILE = 'CGXDCRL0'
     C                   ELSE
     C                   EVAL      DBFILE = 'CGUDCRL0'
     C                   ENDIF
 
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  012
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *  Set Item Status as 'PRTQ' (FormsMaster Print Queue).
      *
     C                   IF        B2ISTS <> 'PPFN'                                           226341
     C                   MOVEL     *BLANKS       DRMSHT                                       226341
     C                   MOVEL     DRISTS        DRMSHT                                       226341
     C                   ENDIF                                                                226341
     C                   EVAL      DRISTS = 'PRTQ'
     C                   IF        #@ARCH = 'A'
     C                   UPDATE    @XDCRL0
     C                   ELSE
     C                   UPDATE    @UDCRL0
     C                   ENDIF
 
      *  Set up the relevant Log file fields for this level.
     C                   CLEAR                   L#UDCL
     C                   EVAL      DLITEM = B2ITEM
     C                   EVAL      DLDCOR = B2DCOR
     C                   EVAL      L#ITEM = B2ITEM
     C                   EVAL      L#DCOR = B2DCOR
     C                   EVAL      DLMSID = 'CGD2538'
     C                   EVAL      DLMSDT = L#MSDT
     C                   EVAL      DLCPGM = 'CG3625'
     C                   EVAL      DLRPGM = 'CG3626'
     C                   EVAL      DLSTFN = AttNbr
 
 
      *  Call program to output log record
     C                   IF        #@ARCH = 'A'
     C                   CALL      'CG9050'
     C                   PARM      *BLANKS       L#Rtcd
     C                   PARM      '*WRITE  '    L#Actn
     C                   PARM                    L#UDCL
     C                   PARM      *BLANKS       L#Titl
     C                   PARM      *BLANKS       L#Ulin
     C                   PARM      'YES'         L#Cmt
 
     C                   ELSE
     C                   CALL      'CG9030'
     C                   PARM      *BLANKS       L#Rtcd
     C                   PARM      '*WRITE  '    L#Actn
     C                   PARM                    L#UDCL
     C                   PARM      *BLANKS       L#Titl
     C                   PARM      *BLANKS       L#Ulin
     C                   PARM      'YES'         L#Cmt
     C                   IF        L#Rtcd = *BLANKS
 
      *  Set charge log record systematically
     C                   CLEAR                   L#UDCL
     C                   EVAL      DLITEM = B2ITEM
     C                   EVAL      DLDCOR = B2DCOR
     C                   IF        B2ISTS = 'PPFN'                                            226341
     C                   EVAL      DLMSID = 'CGD1793'
     C                   ELSE                                                                 226341
     C                   EVAL      DLMSID = 'CGD2623'                                         226341
     C                   ENDIF                                                                226341
     C                   EVAL      DLCPGM = 'CG3625'
     C                   EVAL      DLRPGM = 'CG3626'
     C                   CALL      'CG9030'
     C                   PARM      *BLANKS       L#Rtcd
     C                   PARM      '*WRITE  '    L#Actn
     C                   PARM                    L#UDCL
     C                   PARM      *BLANKS       L#Titl
     C                   PARM      *BLANKS       L#Ulin
     C                   PARM      'YES'         L#Cmt
 
     C                   ENDIF
     C                   ENDIF
 
      *  If error encountered, process database error
     C                   IF        L#Rtcd <> *BLANKS
     C                   IF        #@ARCH = 'A'
     C                   EVAL      DBFILE = 'CGXDCRL0'
     C                   ELSE
     C                   EVAL      DBFILE = 'CGUDCRL0'
     C                   ENDIF
 
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  013
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *  Close file after successful update.
     C                   IF        #@ARCH = 'A'
     C                   CLOSE     CGXDCRL0
     C                   ELSE
     C                   CLOSE     CGUDCRL0
     C                   ENDIF
 
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
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
      * Set job switches
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
      * Pass a value of '*ERROR*' to calling program (i.e. CG5200)
     C                   EVAL      RtnCode = '*ERROR*'
 
      * End program
     C                   RETURN
 
     C                   ENDSR
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Func/GetAttNbr - Retrieve next available Streamfile         ¦
      * ¦                  Attribution Number.                        ¦
      * ¦ Calls: CG3605                                               ¦
      * ¦ Called By: Main Routine                                     ¦
      * +-------------------------------------------------------------+
     PGetAttNbr        B
     DGetAttNbr        PI            35
 
     DRtnCode          S             10
     DAttNbr           S             35
 
      ** Get the initial group set name.
 
     C                   CALLB     'CG3605'
     C                   PARM      *Blanks       RtnCode
     C                   PARM      *Blanks       AttNbr
 
     C                   RETURN    AttNbr
     P                 E
