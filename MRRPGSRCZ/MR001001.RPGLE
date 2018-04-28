     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXS *  RPGCVTOPT2                                                   *
/*EXI *  TEXT('Midas MR Set up MBI signal file and FTP commands')     *
/*X*I****CRTPF******FILE(QTEMP/MSIGNALF)*RCDLEN(100)*******************                     AR844222
/*X*I****RNMOBJ*OBJ(QTEMP/MSIGNALF)*OBJTYPE(*FILE)*NEWOBJ(MSIGNAL)*****                     AR844222
/*XBIC*  CRTSRCPF FILE(QTEMP/FTPCOMMAND) RCDLEN(212) MBR(INPUT)       *
/*XBID*  OVRDBF INPUT FTPCOMMAND INPUT                                *
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR001001 - MBI/Almonde interface                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR844222           Date 05Oct11               *
      *  Prev Amend No. CMR002  *CREATE    Date 14Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR844222 - MBI signal file format update (CCR003)            *
      *  CMR002 - MBI/Almonde Interface                               *
      *                                                               *
      *****************************************************************
      * +------------------+
      * ¦ File declaration ¦
      * +------------------+
 
      * Signal file
     F***MSIGNAL   O    E             DISK    Rename(MSIGNALF:MSIGNALFM)                    AR844222
 
      * Output file for FTP commands
     FINPUT     O    E             DISK
 
      /EJECT
 
      * +-------------------------+
      * ¦ Other standalone fields ¦
      * +-------------------------+
     D RemPathSV       S             20A   Inz('MBIRemotePath')
     D LclPathSV       S             20A   Inz('MBILocalPath')
     D RemUserSV       S             20A   Inz('MBIFTPUserProfile')
     D RemSysSV        S             20A   Inz('MBIRemoteSystem')
     D PathName        S            200A
      *
      * Parameters
     D RtnCode         S              7A
     D LibName         S             10
     D SysName         S              8
     D SysPrefix       S              2
     D*CoBDate**       S              6                                                     AR844222
     D CoBDate         S              8                                                     AR844222
     D FTPUsed         S              1
     D PPath           S            200A                                                    AR844222
     D PFile           S             20A                                                    AR844222
     D PData           S            100A                                                    AR844222
 
      * Parameters to retrieve validation list password (UT000033)
     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A   Inz('GPLDAPVL')
     D PLibrary        S             10A   Inz('*LIBL')
     D PIDName         S            100A
     D PPass1          S            600A
     D PPass2          S            600A
     D PDescr          S           1000A
 
      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
 
      * +----------------------------------+
      * ¦ For *PSSR Error Handling routine ¦
      * +----------------------------------+
     D @RUN            S              1
 
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
      *
      * List of program parameters :
      * --------------------------
 
     C     *Entry        PList
     C                   Parm                    RtnCode
     C                   Parm                    LibName
     C                   Parm                    SysName
     C                   Parm                    SysPrefix
     C                   Parm                    CoBDate
     C                   Parm                    FTPUsed
 
      * Get system values
     C                   Call      'AOSVALR0'
     C                   Parm      *BLANKS       W0RTCD            7
     C                   Parm      RemPathSV     P@OP01           20
     C                   Parm      *BLANKS       P@VL01          200
     C                   Parm      RemUserSV     P@OP02           20
     C                   Parm      *BLANKS       P@VL02          200
     C                   Parm      LclPathSV     P@OP03           20
     C                   Parm      *BLANKS       P@VL03          200
     C                   Parm      RemSysSV      P@OP04           20
     C                   Parm      *BLANKS       P@VL04          200
     C                   Parm      *BLANKS       P@OP05           20
     C                   Parm      *BLANKS       P@VL05          200
     C                   Parm      *BLANKS       P@OP06           20
     C                   Parm      *BLANKS       P@VL06          200
     C                   Parm      *BLANKS       P@OP07           20
     C                   Parm      *BLANKS       P@VL07          200
     C                   Parm      *BLANKS       P@OP08           20
     C                   Parm      *BLANKS       P@VL08          200
     C                   Parm      *BLANKS       P@OP09           20
     C                   Parm      *BLANKS       P@VL09          200
     C                   Parm      *BLANKS       P@OP10           20
     C                   Parm      *BLANKS       P@VL10          200
      *
      * Error if any system values missing or local path not defined
     C                   If        W0RTCD = '*NRF' or
     C                             P@VL03 = *BLANKS
     C                   MoveL     'MR001001'    W0PGM            10
     C                   MoveL     'SDSVALPD'    W0FILE           10
     C                   MoveL     '*KEY   '     W0KEY            10
     C                   Z-Add     001           W0ERNB            5 0
     C                   ExSR      *PSSR
     C                   EndIf
      *
      * If we are to FTP to the remote system, then we need as a minimum
      * the system name and the remote user (the remote path will default
      * to the user's home directory, but a sub directory can optionally
      * be defined).
     C                   If        (P@VL02 = *BLANKS  or
     C                             P@VL04 = *BLANKS) and
     C                             (P@VL02 <>  *BLANKS  or
     C                             P@VL04 <> *BLANKS)
     C                   MoveL     'MR001001'    W0PGM            10
     C                   MoveL     'SDSVALPD'    W0FILE           10
     C                   MoveL     '*KEY   '     W0KEY            10
     C                   Z-Add     002           W0ERNB            5 0
     C                   ExSR      *PSSR
     C                   EndIf
      *
      * If no system values entered for the remote system, then we
      * aren't using FTP, so don't try to get the password or
      * populate the FTP command file.
     C                   If        (P@VL02 = *BLANKS  and
     C                             P@VL04 = *BLANKS)
     C                   Eval      FTPUsed = 'N'
     C                   EndIf
                                                                                            AR844222
     C                   EVAL      PFile = SysPrefix + '_'+                                 AR844222
     C                                     CoBDate + '.signal'                              AR844222
 
      * Get Password
     C                   If        FTPUsed <> 'N'
     C                   Call      'UT000033'
      * Return code.
     C                   Parm                    PReturnCode
      * Action code - Find
     C                   Parm      'F'           PAction
      * Validation list object.
     C                   Parm                    PValidList
      * Library where validation list object is created.
     C                   Parm                    PLibrary
      * ID (100 character).
     C                   Parm      P@VL02        PIDName
      ** Password 1 (600 character)
     C                   Parm                    PPass1
      * Password 2 (600 character), for Edit action this is the new
      *  password. Otherwise set this to blanks.
     C                   Parm                    PPass2
     C                   Parm                    PDescr
 
     C                   If        PReturnCode <>  *Blanks
     C                   ExSr      *PSSR
     C                   EndIf
 
      *  Define the remote path (using the System Value entry if
      * present).
     C                   If        P@Vl01 <> *Blanks
     C                   Eval      PathName = %TRIM(P@Vl01) + '\' +
     C**********                   %TRIM(LibName) + '.SIGNAL'                               AR844222
     C                             %TRIMR(PFile)                                            AR844222
     C                   Else
     C**********         Eval      PathName = %TRIM(LibName) + '.SIGNAL'                    AR844222
     C                   Eval      PathName = PFile                                         AR844222
     C                   EndIf
 
      * Set up the FTP command file
      * User and password
     C                   Eval      SRCDTA = %Trim(P@Vl02) + ' ' + PPass1
     C                   Write     FTPCommand
 
      * Set naming convention
     C                   Eval      SRCDTA = 'NA 1'
     C                   Write     FTPCommand
 
      * Command to actually transfer the file
     C**********         Eval      SRCDTA = 'PUT /QDLS/' + %Trim(P@Vl03) +                  AR844222
     C**********                   '/' + %TRIM(LibName) + '.SIG ' +                         AR844222
     C                   EVAL      SRCDTA = 'PUT /' + %TRIMR(P@Vl03) +                      AR844222
     C                             '/' + %TRIMR(PFile) +                                    AR844222
     C                             PathName
     C                   Write     FTPCommand
 
      ** Set Quit message
     C                   Eval      SRCDTA = 'QUIT'
     C                   Write     FTPCommand
     C                   EndIf
 
      ***Format*signal*data*as*CSV*and*write*to*temporary*file*********                     AR844222
      **<BF*Midas*iSeries*Name>,<Subsystem prefix>,<CoB_date>,<library name>                AR844222
     C**********         Eval      MSIGNALF =  SysName + ',' + SysPrefix + ','+             AR844222
     C**********                   CoBDate + ',' + LibName                                  AR844222
     C**********         Write     MSIGNALFM                                                AR844222
                                                                                            AR844222
      ** Write Signal File to Stream File                                                   AR844222
                                                                                            AR844222
     C                   EVAL      PPath  =  P@VL03                                         AR844222
     C                   EVAL      PData  =  SysName+','+SysPrefix+                         AR844222
     C                                       ','+CoBDate+','+LibName                        AR844222
     C                   CALL      'MR001005'                                               AR844222
     C                   PARM                    PPath                                      AR844222
     C                   PARM                    PFile                                      AR844222
     C                   PARM                    PData                                      AR844222
 
      * End program
     C                   Eval      *InLR = *On
     C                   Return
 
      /EJECT
      * +-------------------------------------------------------------+
      * ¦ Subr/*PSSR - Program Exception Error Handling Routine       ¦
      * ¦              Called automatically if a program error occurs,¦
      * ¦              or directly by the program code using EXSR.    ¦
      * ¦              This subroutine DUMPs the program just once.   ¦
      * +-------------------------------------------------------------+
     C     *PSSR         BegSR
 
      *
     C                   If        @RUN = *BLANK
 
      * Prevent recursive errors
     C                   Eval      @RUN = 'Y'
 
      * Set return code and dump the program
     C                   Eval      RtnCode = '*Error*'
     C                   Dump
     C                   EndIf
 
      * Set job switches
     C                   Eval      *InLR = *On
 
      * End program
     C                   Return
 
     C                   EndSR
 
      /EJECT
