      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Copy data from one library to another')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000022 - Display objects not found                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27793 *CREATE   Date 11Jun10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27793 - Make migration multi-streamed.                    *
      *                                                               *
      *****************************************************************
     FSM000022DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(FMT1:rrn)
     FSMCPYDL0  UF   E           K DISK    INFSR(*PSSR)
      *
     D NoRecord        S              1
     D J               S              3  0
     D rrn             S              3  0
     D ReturnCode      S             10
     D Recursive       S              1    INZ(' ')
      *
     D PSDS           SDS
     D  PGM              *PROC
     D  SWSID                244    253
     D  SUSER                254    263
      *
      * DS to convert fields to display sizes
     D                 DS
     D  ODOBTX                 1     50
     D  XXTEXT                 1     47
     D  ODOBAT                51     60
     D  XXTYPE                51     56
      *
      **DS to check for duplicated entries
     D*                DS
     D* ODOBNM                 1     10
     D* ODOBTP                11     18
     D* DUPNAM                 1     18
      *
     C     NotFound      KLIST
     C                   KFLD                    ODOBNM
     C                   KFLD                    ODOBTP
      *
      * Clear spurious and duplicate entries from SMCPYDPD
     C     *IN03         DOWEQ     *OFF
      *
      * Build subfile
     C                   EVAL      NoRecord = 'N'
     C                   EXSR      Build
      *
      * If no records, send blank format, otherwise send subfile
     C                   IF        NoRecord = 'N'
     C                   EXFMT     NORCD
     C                   ELSE
     C                   WRITE     FMT0
     C                   EXFMT     FMT2
     C                   ENDIF
      *
      * If F3 pressed, exit program.
     C                   IF        *IN03 = *ON
     C                   ELSE
      *
      * If F5 pressed, rebuild subfile
     C                   IF        *IN05 = *ON
     C     *LOVAL        SETLL     SMCPYDL0
      *
     C                   ELSE
      *
      * If subset and/or reposition selected, rebuild from requested
      * position/with requested subset.  Indicator 01 is set on if
      * any field in the format has changed, so it caters for the user
      * changing the selection details and pressing enter again.
      *   if... (
     C                   IF        XXPOS <> *blank and
     C                             *IN01 = *ON or
      *         )
      *   or... (
     C                             XXSUB <> *blank and
     C                             *IN01 = *ON
      *         )
      *
     C     XXPOS         SETLL     SMCPYDL0
      *
     C                   ELSE
     C                   IF        NoRecord = 'Y'
     C                   READC     FMT1                                   21
      *
      * If *IN21 is on, no selection has been made - rebuild.
     C                   IF        *IN21 = *ON
     C     *LOVAL        SETLL     SMCPYDL0
     C                   ELSE
      *
      * Retrieve selected line from array and process selection
      *       D = Delete object from file
      *       O = Display object description
      *       V = View contents
      *       X = Perform action
      *
     C                   DOW       *IN21 = *OFF
      *
      * Selection D - Remove object from DSPOBJD outfile.
     C                   IF        XXOPT = 'D'
     C     NotFound      CHAIN     SMCPYDL0
     C                   IF        %FOUND
     C                   EVAL      ODDDAT = 'PASSED'
     C                   UPDATE    QLIDOBJD
     C                   ENDIF
      *
     C                   ENDIF
      *
      * All other commands are handled by CL program.
     C                   IF        XXOPT = 'O' or
     C                             XXOPT = 'V' or
     C                             XXOPT = 'X'
     C                   CALL      'UPC0261'
     C                   PARM                    XXOPT
     C                   PARM                    ODOBNM
     C                   PARM                    ODLBNM
     C                   PARM                    ODSCMD
     C                   PARM                    ODOBAT
     C                   PARM                    ODOBTP
     C                   PARM                    ODSRCL
     C                   PARM                    ODSRCF
     C                   PARM                    ReturnCode
      *
      * Selection X - process request.
     C                   IF        XXOPT = 'X'
      *
      * If object has been created, update SMCPYDPD.
     C                   IF        ReturnCode = 'Exist'
     C     NotFound      CHAIN     SMCPYDL0
     C                   IF        %FOUND
     C                   EVAL      ODDDAT = 'PASSED'
     C                   UPDATE    QLIDOBJD
     C                   ENDIF
     C                   CLEAR                   ReturnCode
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   READC     FMT1                                   21
      *
      * If previous option ended in error, force rebuild of subfile.
     C                   IF        ReturnCode = 'Error'
     C                   EVAL      *IN21 = *ON
     C                   CLEAR                   ReturnCode
     C                   ENDIF
     C                   ENDDO
      *
      *  Reset file
     C     XXPOS         SETLL     SMCPYDL0
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      ********************************************************************
      *   BUILD Subroutine - Build subfile                               *
      ********************************************************************
      *
     C     Build         BEGSR
      *
      * Initialise.
     C                   DOU       %EOF
     C                   EVAL      XXOPT = *blanks
     C                   EVAL      J = 0
     C                   EVAL      rrn = 1
      *
     C                   EVAL      *IN30 = *ON
     C                   WRITE     FMT2
     C                   EVAL      *IN30 = *OFF
      *
     C                   READ      SMCPYDL0
      *
      * Build subfile
     C                   DOW       NOT(%EOF)
     C                   EVAL      NoRecord = 'Y'
      *
     C                   IF        ODDDAT = 'NFOUND'
      * Create meaningful 'type' descriptions for those instances where
      * ODOBAT is blank.
     C                   IF        ODOBTP = '*CMD'    or
     C                             ODOBTP = '*PNLGRP' or
     C                             ODOBTP = '*DTAARA' or
     C                             ODOBTP = '*SRVPGM' or
     C                             ODOBTP = '*BNDDIR' or
     C                             ODOBTP = '*TBL'    or
     C                             ODOBTP = '*USRSPC' or
     C                             ODOBTP = '*DTAQ'   or
     C                             ODOBTP = '*MSGF'
     C                   EVAL      ODOBAT = %SUBST(ODOBTP:2:7)
     C                   ENDIF
      *
      * A program and a module with the same name both have an attribute
      * of RPGLE or CLLE; change the program's attribute to PGM for clarity.
     C                   IF        ODOBTP = '*PGM' and
     C                             ODOBAT = 'RPGLE' or
     C                             ODOBTP = '*PGM' and
     C                             ODOBAT = 'CLLE'
     C                   EVAL      XXTYPE = 'PGM  '
     C                   ENDIF
      *
      * If subset requested only select matching records, otherwise
      * select all.
     C                   IF        XXSUB = *blank or
     C                             XXSUB = ODOBAT
     C                   EVAL      J = J + 1
      *
     C                   WRITE     FMT1
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      rrn = rrn + 1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      SMCPYDL0
     C                   ENDDO
     C                   EVAL      *IN50 = *ON
      *
      * If subset requested and no matches found, rebuild.
     C                   IF        XXSUB <> *blank and
     C                             J = 0
     C     *LOVAL        SETLL     SMCPYDL0
     C                   EVAL      XXSUB = *blank
     C                   EVAL      *IN50 = *OFF
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If all records in subset found, reset subset parameter
     C                   IF        %EOF
     C                   EVAL      XXSUB = *blank
     C                   EVAL      XXPOS = *blank
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive <> 'Y'
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
 
     C                   ENDSR
      *
