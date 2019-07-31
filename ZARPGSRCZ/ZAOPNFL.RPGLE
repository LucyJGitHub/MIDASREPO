     H DEBUG DATEDIT(*DMY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZA Get list of open files')
      *****************************************************************
      *                                                               *
      *  Midas - Common programs                                      *
      *                                                               *
      *  ZAOPNFL    -  Retrieve current job's list of open files      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG8931 *CREATE    Date  7Nov05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG8931  Check to ensure printer file is open                *
      *                                                               *
      *****************************************************************
      **  Program description:
      **
      **    This program retrieves the current job's list of open files.
      **    The information returned is the file names and file library
      **    names that are displayed by the DSPJOB or WRKJOB command's
      **    open files panel.  Running the command DSPJOB OPTION(*OPNF)
      **    will show the information referred to above.
      **
      **    Parameters
      **
      **    PxEntNbr    BOTH       The maximum number of open file entries
      **                           to return in the output array.  A maximum
      **                           of 128 open file entries can be returned.
      **
      **                           On return this parameter specifies the
      **                           actual number of open file entries loaded
      **                           in the second parameter.
      **
      **    PxFilEnt    OUTPUT     The retrieved open file entries are returned
      **                           in this parameter. Both the file name and the
      **                           file library name is returned for each open
      **                           file entry as illustrated below:
      **
      **                           1            21           41
      **                           |  entry 1   |  entry 2   |  entry 3   | --
      **
      **                           1      11    21     31    41     51
      **                           | file | lib | file | lib | file | lib | --
      **
      **
      **-- API error data structure:  -----------------------------------------**
     D ApiError        Ds
     D  AeBytPrv                     10i 0 Inz( %Size( ApiError ))
     D  AeBytAvl                     10i 0
     D  AeMsgId                       7a
     D                                1a
     D  AeMsgDta                    256a
      **-- Global variables:  -------------------------------------------------**
     D Eix             s             10i 0
      **-- Job identification format JIDF0100:  -------------------------------**
     D JiJobInf        Ds                   Inz
     D  JiJobNam                     10a    Inz( '*' )
     D  JiUsrNam                     10a
     D  JiJobNbr                      6a
     D  JiIntJobId                   16a
     D                                2a    Inz( *Allx'00' )
     D  JiThrInd                     10i 0  Inz( 1 )
     D  JiThrId                       8a    Inz( *Allx'00' )
      **-- List open files header:  -------------------------------------------**
     D OfRcvVar        Ds
     D  OhOpnFilHdr
     D   OhBytRtn                    10i 0 Overlay( OhOpnFilHdr: 1 )
     D   OhBytAvl                    10i 0 Overlay( OhOpnFilHdr: *Next )
     D   OhNbrFilAvl                 10i 0 Overlay( OhOpnFilHdr: *Next )
     D   OhOfsFilLst                 10i 0 Overlay( OhOpnFilHdr: *Next )
     D   OhNbrFilRtn                 10i 0 Overlay( OhOpnFilHdr: *Next )
     D   OhFilEntLen                 10i 0 Overlay( OhOpnFilHdr: *Next )
     D   OhJobNamUsd                 10a   Overlay( OhOpnFilHdr: *Next )
     D   OhUsrNamUsd                 10a   Overlay( OhOpnFilHdr: *Next )
     D   OhJobNbrUsd                  6a   Overlay( OhOpnFilHdr: *Next )
     D   OhThrIdUsd                   8a   Overlay( OhOpnFilHdr: *Next )
     D   OhFilLst                 32000a
      **-- File information----------------------------------------------------**
     D OfFilInf        Ds                  Based( pFilInf )
     D   OeFilNam                    10a
     D   OeFilLib                    10a
     D   OeMbrNam                    10a
     D   OeFilTyp                    10a
     D   OeRcdFmt                    10a
     D   OeActGrpNam                 10a
     D   OeThrId                      8a
     D   OeOpnOpt                     1a
     D                                3a
     D   OeActGrpNbr                 20i 0
     D   OeWrtCnt                    20i 0
     D   OeReadCnt                   20i 0
     D   OeWrtReadCnt                20i 0
     D   OeOthIoCnt                  20i 0
     D   OeRelRcdNbr                 20i 0
     D   OeNbrShrOpn                 20i 0
      **-- List open files:  --------------------------------------------------**
     D LstOpnF         Pr                  ExtPgm( 'QDMLOPNF' )
     D  LfRcvVar                  32767a          Options( *VarSize )
     D  LfRcvVarLen                  10i 0 Const
     D  LfRcvInfFmt                   8a   Const
     D  LfJobId                   32767a   Const  Options( *VarSize )
     D  LfJobIdFmt                    8a   Const
     D  LfError                   32767a          Options( *VarSize )
      **-- Parameters:  -------------------------------------------------------**
     D PxEntNbr        s              5p 0
     D PxFilEnt        s             20a   Dim( 128 )
      **
     C     *Entry        Plist
     C                   Parm                    PxEntNbr
     C                   Parm                    PxFilEnt
      **
      **-- Mainline:  ---------------------------------------------------------**
      **
     C                   CallP     LstOpnF( OfRcvVar
     C                                    : %Size( OfRcvVar )
     C                                    : 'OPNF0100'
     C                                    : JiJobInf
     C                                    : 'JIDF0100'
     C                                    : ApiError
     C                                    )
      **
     C                   If        AeBytAvl   =  *Zero
     C                   Eval      pFilInf    =  %Addr( OfRcvVar ) +
     C                                           OhOfsFilLst
      **
     C                   For       Eix = 1  to OhNbrFilRtn
      **
     C                   Eval      PxFilEnt(Eix) = OeFilNam + OeFilLib
      **
     C                   If        Eix         = PxEntNbr      Or
     C                             Eix         = OhNbrFilRtn   Or
     C                             Eix         = OhNbrFilRtn   Or
     C                             Eix         = %Elem( PxFilEnt )
      **
     C                   Leave
     C                   EndIf
      **
     C                   Eval      pFilInf     = pFilInf + OhFilEntLen
     C                   EndFor
     C                   EndIf
      **
     C                   Eval      PxEntNbr    = Eix
      **
     C                   Eval      *InLr      =  *On
     C                   Return
      **
