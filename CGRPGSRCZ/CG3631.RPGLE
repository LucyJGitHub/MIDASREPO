     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas CG Create iSeries IFS Directory')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3631 - Create iSeries IFS Directory                        *
      *                                                               *
      *  Function: This program is run during setup of                *
      *            Correspondence Manager module ICD which            *
      *            creates AS/400 IFS directories. The                *
      *            directories created will either hold the           *
      *            XML data transmitted to FormsMaster or the         *
      *            feedback data received from FormsMaster.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSD053             Date 07Jul06               *
      *  Prev Amend No. CCG015  *CREATE    Date 11Feb02               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade.       *
      *         - Recompile due to SDCORMPD.                          *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
 
      /EJECT
      * +--------------------------------------+
      * ¦ Prototypes required for the IFS APIs ¦
      * +--------------------------------------+
      /COPY CGCPYSRC,IFSPROTO
 
      * +-----------------------------------------------+
      * ¦ API definitions for oflag and mode parameters ¦
      * +-----------------------------------------------+
      /COPY CGCPYSRC,OPENDFN
 
      * +-------------------------------------------------+
      * ¦ Variable declaration for the IFS APIs used here ¦
      * +-------------------------------------------------+
     D Mode            S             10I 0 INZ
     D RC              S             10I 0
 
      * +----------------------------------+
      * ¦ For *PSSR Error Handling routine ¦
      * +----------------------------------+
     D @Run            S              1A
 
      * +-----------------------+
      * ¦ Parameter declaration ¦
      * +-----------------------+
     D Rtcd            S              7A   INZ(*BLANK)
     D Optn            S              7A   INZ(*BLANK)
     D DirPara         S             75A
     D RtnCode         S             10A
 
      * +----------------------------+
      * ¦ Other standalone variables ¦
      * +----------------------------+
     D DirName         S             75A
     D X               S              2  0
     D Y               S              2  0
     D DirArr1         S              1    DIM(75)
     D DirArr2         S              1    DIM(75)
 
      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
     D Slash           C                   CONST('/')
 
      * +-----------------------------------------------+
      * ¦ Data structure for Correspondence Manager ICD ¦
      * +-----------------------------------------------+
     D Sdcorm        E DS                  EXTNAME(SDCORMPD)
 
      * +-----------------------------------------------+
      * ¦ Data Structure (long) used by Access Programs ¦
      * +-----------------------------------------------+
     D Dsldy         E DS                  EXTNAME(DSLDY)
 
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
 
      *  Only create iSeries directory if parameter passed is not blank.
     C                   IF        DirPara <> *BLANKS
 
      *  Process the Directory name and then create as required
     C                   EXSR      CREATEDIR
 
      *  If parameter passed is blank, send *ERROR return code and end
      *  end program.
 
     C                   ELSE
     C                   EVAL      RtnCode = '*ERROR    '
     C                   ENDIF
 
      *  Terminate the program
     C                   RETURN
 
      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/*INZSR - Initialisation subroutine                          ¦
      * +------------------------------------------------------------------+
     C     *INZSR        BEGSR
 
      *  Entry parameter
 
     C     *ENTRY        PLIST
     C                   PARM                    RtnCode
     C                   PARM                    DirPara
 
     C                   ENDSR
 
      /EJECT
      * +---------------------------------------------------------+
      * ¦ Subr/CREATEDIR - Explore the Directory Name and create  ¦
      * ¦                  each subdirectories as required.       ¦
      * +---------------------------------------------------------+
     C     CREATEDIR     BEGSR
 
      *  Load Directory name into an array field
     C                   MOVEA     DirPara       DirArr1
 
      *  Initialise work array indeces and set indicator *IN20 = *ON
      *  (this is to simulate a successful 'initial' lookup operation
      *   and to enable the Do While (DOW) operation below).
     C                   EVAL      X = 1
     C                   EVAL      Y = 1
     C                   EVAL      *IN20 = *ON
 
      *  Continue scanning Directory name until no slash is found.
     C                   DOW       *IN20 = *ON
 
      *  Increment index to a value of 2 for 'first time' lookup to
      *  bypass the first slash (i.e. the root directory). At this
      *  point, we are only interested if the directory to be created
      *  is a subdirectory (i.e. '/<dir1>/<dir2>' where <dir2> is a
      *  subdirectory of <dir1>).
     C                   EVAL      X = X + 1
     C     Slash         LOOKUP    DirArr1(X)                             20
 
      *  If slash is found, process the directory name.
     C                   IF        *IN20 = *ON
 
     C                   DOU       Y = X
     C                   MOVE      DirArr1(Y)    DirArr2(Y)
     C                   EVAL      Y = Y + 1
     C                   ENDDO
 
      *  Move the directory name extracted to a character field
      *  and create it.
     C                   MOVEA     DirArr2       DirName
     C                   EXSR      MAKEDIR
 
     C                   ENDIF
 
     C                   ENDDO
 
      *  Load the last remaining directory to create
     C                   MOVEA     DirArr1(Y)    DirArr2(Y)
     C                   MOVEA     DirArr2       DirName
     C                   EXSR      MAKEDIR
 
      *  If error creating the directory...
     C                   IF        RC = -1
     C                   EVAL      RtnCode = '*NOCREATE '
     C                   ELSE
     C                   EVAL      RtnCode = '*CREATE   '
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      * +--------------------------------------------------+
      * ¦ Subr/MAKEDIR - Create the AS/400 Local Directory ¦
      * +--------------------------------------------------+
     C     MAKEDIR       BEGSR
 
      *  Set file mode parameter
     C                   EVAL      Mode = S_IRWXU + S_IRWXG +
     C                                    S_IRWXO
 
      *  Create the AS/400 local directory
     C                   EVAL      RC = mkdir(%TRIM(DirName):Mode)
 
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
 
      * End program
     C                   RETURN
 
     C                   ENDSR
