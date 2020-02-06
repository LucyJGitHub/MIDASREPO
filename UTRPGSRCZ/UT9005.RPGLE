      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT CPP for UPDGENFLD')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities module                                     *
      *                                                               *
      *  UT9005 - CPP for UPDGENFLD.  This program stores the list of *
      *           API definition files that define a particular API.  *
      *           Field numbers are generated from this by GENFLDNOS. *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.03 ----------------------------------------*
      *  Prev Amend No. CUP021  *CREATE    Date 12Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP021 - Creation of UPDGENFLD command.  This is part of a   *
      *           re-write of GENFLDNOS, to make it file driven.      *
      *                                                               *
      *****************************************************************
     FUTGENFL0  UF A E           K DISK
      /EJECT
      *
      /SPACE 3
      *
      ** Data structure to convert the (binary) number of files in the command array
     D                 DS
     D BinaryNbr               1      2B 0
     D WorkField               1      2
      *
      ** Data structure to create parameter for call to UTC9005
     D WorkParm        DS
     D Detail                  3    402
 
      * Set up messages for Midas Information Screen
     D MidasMsg        DS           800
     D Msg1                  101    150
     D Msg2                  201    250
     D Const2          C                   Const('Check joblog for details')
      *
      * Constant for comparison if input is an extension list
     D Extend          C                   Const('*EXTEND')
 
      * Parameters for QCMDEXC
     D Qcmd            C                   Const('CRTDTAARA DTAARA(QTEMP/+
     D                                     MIDASMSG) TYPE(*CHAR) LEN(800) +
     D                                     VALUE('' '')')
      *
     C     *ENTRY        PLIST
     C                   PARM                    InAPIName         4
     C                   PARM                    DetailFiles     402
     C                   PARM                    HeaderFile       20
 
     C     GLIST         KLIST
     C                   KFLD                    KAPI              4
     C                   KFLD                    KSEQ              2 0
      *
      * Get the header file details to check whether this is an extension
      * list or not
     C     10            Subst     HeaderFile    Check            10
      *
      * Get the number of elements in the array (first two characters in
      * DetailFiles, in binary), and, if there is a header file add 1 to
      * get the total number of files.
     C     2             Subst     DetailFiles:1 WorkField
     C                   Z-Add     BinaryNbr     NbrOfFiles        2 0
     C                   If        Check <> Extend
     C                   Add       1             NbrOfFiles
     C                   EndIf
      *
      * Check whether records exist for this API - if so, then:
      *  if this is an extension list, read to the end to get last sequence no
      *  if not an extension list, delete any existing records
     C                   Z-ADD     1             KSEQ
     C                   EVAL      KAPI = InAPIName
     C     GLIST         CHAIN     UTGENFL0                           99
      *
     C     HFAPIN        DOWEQ     InAPIName
     C     *IN99         ANDEQ     *OFF
     C                   If        Check <> Extend
     C                   DELETE    UTGENFD0
     C                   EndIf
     C                   READ      UTGENFD0                               99
     C                   ENDDO
      *
      * Write the header record
     C                   If        Check <> Extend
      *
      * Extract header file details
     C     10            Subst     HeaderFile    HFFILE
     C     10            Subst     HeaderFile:11 HFFLIB
     C                   Z-Add     1             HFSEQN
     C                   Eval      HFAPIN = InAPIName
     C                   WRITE     UTGENFD0
     C                   EndIf
      *
      * Set up detail file counter and array index
      *  - counter starts at two as the header file is the first file,
      *    unless this is an *EXTEND operation (see below)
      *  - array index starts at 3 because of the array counter above
     C                   If        Check <> Extend
     C                   Z-Add     2             Counter
     C                   Else
      *
      * If this is an *EXTEND operation, read previous to get the last sequence
      * number.  Add 1 to get the next sequence number; also add to the number-
      * of-files counter.
     C                   READP     UTGENFD0                               99
     C     HFSEQN        Add       1             Counter           2 0
     C                   Add       HFSEQN        NbrOfFiles
     C                   EndIf
     C                   Z-Add     3             P                 3 0
      *
      * Loop through array, extract file details, and write
     C     Counter       DOWLE     NbrOfFiles
     C     10            SUBST     DetailFiles:P HFFILE
     C                   Add       10            P
     C     10            SUBST     DetailFiles:P HFFLIB
     C                   Add       10            P
     C                   Z-Add     Counter       HFSEQN
     C                   WRITE     UTGENFD0
     C                   Add       1             Counter
     C                   ENDDO
      *
      * Exit
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine calls the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
      * Set up data area for Midas Information Screen
     C                   If        @RUN <> 'Y'
     C                   MOVE      'Y'           @RUN              1
     C     *DTAARA       Define                  MidasMsg
     C                   Call      'UTCHKOBJ'
     C                   Parm      *Blanks       ReturnCode       10
     C                   Parm      'MidasMsg'    Object           10
     C                   Parm      'QTEMP'       ObjLib           10
     C                   Parm      '*DTAARA'     ObjType           7
     C                   Parm                    Member           10
      *
     C                   If        ReturnCode  = 'NotExist  '
     C                   Call      'QCMDEXC'
     C                   Parm      Qcmd          QcmdExc         100
     C                   Parm      100           CmdLen           15 5
     C                   EndIf
      *
     C     *LOCK         In        MidasMsg
     C                   CALL      'Y2RVMGC'
     C                   PARM                    W0RTN             7
     C                   PARM      'UPM0001'     ZAMSID            7
     C                   PARM      'UTMSGF'      ZAMSGF           10
     C                   PARM      'UT9007'      ZAMSDA          132
     C                   PARM                    ZAMSTX          132
 
     C                   Eval      Msg1 = %subst(ZAMSTX:1:50)
     C                   Eval      Msg2 = Const2
     C                   Out       MidasMsg
      *
     C                   CALL      'SCC0010'
     C                   PARM      'UPDGENFLD'   CallingPgm       10
     C                   PARM      'JOBLOG  '    Option           10
     C                   PARM      'Y'           Default           1
      *
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDSR
      *
      ********************************************************************
