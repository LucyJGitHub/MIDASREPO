     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas End GP_UTU_MGR and GPUTU* jobs')                 *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCC000302 - End GP_UTU_MGR and GPUTU* jobs                   *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD042877  *CREATE  Date 11Mar24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD042877 - SCKOBJLCB 00001 failed due to GPUTU* job not ended*
      *           - Applied for MD-62365.                             *
      *                                                               *
      *****************************************************************
      *
      ** Process the flat file
      *
     FDSPSBJ    IF   F  132        DISK    USROPN
      *
     D Qcmdexc         pr                  Extpgm('QCMDEXC')
     D  cmd                         200A   Options(*Varsize) Const
     D  cmdlen                       15P 5 Const
      *
     D JOBID           S             28
     D CMD             S            200A
     D PCMDLEN         S             15P 5
     D PLOOP           S              1A
     D NoOfAttempts    S              2S 0
     D PEND            S             10A
      *
     IDSPSBJ    AA
     I                                  1  132  RECORD
     I                                  4   13  JOBNAME
     I                                  4    8  JOBNAM2
     I                                 17   26  USER
     I                                 29   34  JOBNUM
     I                                116  119  STATUS
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLOOP
     C                   PARM                    PEND
      *
      ** Only process lines with valid job numbers (skip headings, etc.)
      *
     C                   OPEN      DSPSBJ                               99
      *
     C     1             SETLL     DSPSBJ
     C                   READ      DSPSBJ                                 01
      *
     C     *IN01         DOWEQ     '0'
      *
     C                   if        %check('1234567890':JOBNUM) = 0
      *
      ** Compare for selected job named
      *
      ** End GP_UTU_MGR jobs
     C                   IF        JOBNAME = 'GP_UTU_MGR'
      *
     C                             OR JOBNAM2 = 'GPUTU'
     C                             AND STATUS = 'DEQW'
      *
      ** Setup qualified receiver name.
      *
     C                   EVAL      JOBID = JOBNUM + '/' + %Trim(USER) + '/' +
     C                              %Trim(JOBNAME)
     C                   EVAL      CMD = 'ENDJOB JOB(' + %Trim(JOBID) +
     C                              ') OPTION(*IMMED) DELAY(1)'
     C                   CallP(e)  Qcmdexc(CMD : %Len(%Trim(CMD)))
      *
     C                   ENDIF
      *
     C                   IF        JOBNAM2 = 'GPUTU'
     C                             AND STATUS <> 'DEQW'
     C                   EVAL      PLOOP = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      DSPSBJ                                 01
      *
     C                   ENDDO
      *
     C                   CLOSE     DSPSBJ
     C                   RETURN
      *
