/*STD *  CM                                                          */
/*EXI *  SYSIFCOPT(*IFSIO)                                           */
/*EXI *  TEXT('Midas @24 KWG transmission file copy')
     /****************************************************************/
     /*                                                              */
     /*  Midas - European Reporting Module                           */
     /*                                                              */
     /*  ER000103 - Copy transmission data to stream file.           */
     /*                                                              */
     /*  Function  : This module Copy transmission data to stream    */
     /*              file.                                           */
     /*                                                              */
     /*  (c) Finastra International Limited 2008                     */
     /*                                                              */
     /*  Last Amend No. MD046248              Date 27Oct17           */
     /*  Prev Amend No. CER059                Date 19Jul10           */
     /*                 CER047  *CREATE       Date 19May08           */
     /*                                                              */
     /****************************************************************/
     /*                                                              */
     /*  MD046248 - Finastra Rebranding                              */
     /*  CER059 - German Feature Upgrade to Delhi                    */
     /*  CER047 - German Features LF037-00 Reporting @24c KWG        */
     /*                                                              */
     /****************************************************************/
     /*  Purpose                                                     */
     /*  ~~~~~~~                                                     */
     /*  This program copies the data for transmission to a stream   */
     /*  file. The data is stored in workfile GWV10P.                */
     /*  The stream file can be located in any directory of the IFS. */
     /*  If it does not yet exist it will be automatically created.  */
     /*  The complete path of the stream file is passed as parameter */
     /*  to this program.                                            */
     /****************************************************************/
     /*    Compilation Options for command CRTBNDC                   */
     /*    Keywords              Keyword choices                     */
     /*C   OUTPUT(*PRINT)      - {*PRINT or *NONE}                   */
     /*C   OPTION(*SHOWUSR)    - {*NONE or <compiler option>}        */
     /*C   DBGVIEW(*LIST)      - {*NONE,*ALL,*STMT,*SOURCE or *LIST} */
     /*C   SYSIFCOPT(*NOIFSIO) - {*NOIFSIO or *IFSIO}                */
     /****************************************************************/

#include <stdio.h>
#include <recio.h>
#include <stdlib.h>
#include <string.h>
#include <decimal.h>
#include <fcntl.h>
#include <unistd.h>

/* Include the external definition of the database file GWV10P.      */
/* The #pragma statement creates a typedef struct that holds the     */
/* structure of the database file. This structure is then imported   */
/* by the #include statement.                                        */

#ifdef __cplusplus
#include <bcd.h>
#else
#include <decimal.h>
#endif

typedef _Packed struct {

#ifndef __cplusplus
   decimal( 4, 0) F1WLEN;
#else
   _DecimalT< 4, 0> F1WLEN;              /* Length of data */
                                         /* BCD class SPECIFIED IN DDS */
#endif
   char F1WDTA[2000];                    /* Data */
} ERTSNDPD_ERTSNDD0_i_t;


/* Define work values.                                               */

#define OK                0
#define OPENSTMFFAILED    1
#define OPENDBAFFAILED    2
#define WRITESTMFFAILED   3

/* Main procedure.                                                   */
/* One parameter is passed from the calling program, consist of      */
/* full path of the file to copy too. This parameter must be         */
/* passed as NULL terminated string.                                 */

int ER000103(const char *stmfile)
{

/* Declare rcd, dta of data structure type                           */
/* ERTSNDPD_ERTSNDD0_i_t.                                            */
/* The data structure type was defined from the DDS specified (see   */
/* #pragma statement above).                                         */

  ERTSNDPD_ERTSNDD0_i_t rcd, *dta = &rcd;
  _RFILE       *in;
  _RIOFB_T     *fb;
  char         *dbfile   = "ERTSNDPD";
  int          fildes;

/* Open and create the stream file using the open() Integrated       */
/* File System API.                                                  */

  fildes = open( stmfile, O_WRONLY¦O_CREAT¦O_TRUNC, S_IRWXU );
  if (fildes == -1)
  {
    return OPENSTMFFAILED;
  }
  else
  {

/* Open the database file for processing in arrival sequence.        */

    if (( in = _Ropen( dbfile, "rr, arrseq=Y" )) == NULL )
    {
      return OPENDBAFFAILED;
    }
    else
    {

/* Read a record of the database file.                               */

      fb = _Rreadn( in, dta, in->buf_length, __DFT );

/* Loop until end of file not reached.                               */

      while ( fb->num_bytes != EOF )
      {

/* Write the buffer to the stream file using the Integrated File     */
/* System write() API                                                */

        if (( write( fildes, rcd.F1WDTA, rcd.F1WLEN )) == -1)
          return WRITESTMFFAILED;

/* Read next record of the database file.                            */

        fb = _Rreadn( in, dta, in->buf_length, __DFT );
      };

/* Close database file.                                              */

      _Rclose( in );
    };

/* Close stream file.                                                */

    close ( fildes );
  };
  return OK;
}
